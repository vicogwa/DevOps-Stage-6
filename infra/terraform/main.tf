terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
   backend "s3" {
    bucket         = "devops-stage6-terraform-state"  
    key            = "devops-stage-6/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"  # ADD THIS
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "app_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name = "todo-app-server"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              EOF
}

resource "aws_security_group" "app_sg" {
  name        = "todo-app-sg"
  description = "Security group for TODO app"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.tpl", {
    server_ip = aws_instance.app_server.public_ip
  })
  filename = "${path.module}/../ansible/inventory"
}

resource "null_resource" "run_ansible" {
  depends_on = [aws_instance.app_server, local_file.ansible_inventory]

  provisioner "local-exec" {
    command = "cd ${path.module}/../ansible && ansible-playbook -i inventory playbooks/deploy.yml"
  }

  triggers = {
    instance_id = aws_instance.app_server.id
  }
}

