provider "aws" {
  region = var.aws_region
}

# Data source for latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security Group
resource "aws_security_group" "todo_app_sg" {
  name        = "todo-app-security-group"
  description = "Security group for TODO application"

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
    description = "SSH access"
  }

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS access"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = {
    Name        = "todo-app-sg"
    Environment = "production"
    ManagedBy   = "Terraform"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# EC2 Instance
resource "aws_instance" "todo_app_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.todo_app_sg.id]

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    delete_on_termination = true
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y python3 python3-pip
              EOF

  tags = {
    Name        = "todo-app-server"
    Environment = "production"
    ManagedBy   = "Terraform" 
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [user_data]
  }
}

# Generate Ansible inventory dynamically
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory_template.tpl", {
    server_ip       = aws_instance.todo_app_server.public_ip
    ssh_key_path    = var.ssh_private_key_path
    domain_name     = var.domain_name
    github_repo_url = var.github_repo_url
  })
  filename = "${path.module}/../ansible/inventory.ini"

  depends_on = [aws_instance.todo_app_server]
}

# Wait for instance to be ready
resource "null_resource" "wait_for_instance" {
  depends_on = [aws_instance.todo_app_server, local_file.ansible_inventory]

  provisioner "local-exec" {
    command = "sleep 60"  # Wait for instance to fully boot
  }

  triggers = {
    instance_id = aws_instance.todo_app_server.id
  }
}

# Run Ansible playbook after Terraform provisioning
resource "null_resource" "run_ansible" {
  depends_on = [null_resource.wait_for_instance]

  provisioner "local-exec" {
    command = <<-EOT
      cd ${path.module}/../ansible && \
      ansible-playbook -i inventory.ini playbook.yml
    EOT
  }

  triggers = {
    instance_id        = aws_instance.todo_app_server.id
    inventory_content  = local_file.ansible_inventory.content
  }
}
