terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "app_sg" {
  name_prefix = "microservices-app-"
  description = "Security group for microservices application"

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

  tags = {
    Name = "microservices-app-sg"
  }
}

resource "aws_instance" "app_server" {
  ami            = var.ami_id
  instance_type  = var.instance_type
  key_name       = var.key_name
  security_groups = [aws_security_group.app_sg.name]

  tags = {
    Name = "microservices-app-server"
  }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    server_ip = aws_instance.app_server.public_ip
    key_path  = var.private_key_path
  })

  filename = "${path.module}/../ansible/inventory.ini"
  depends_on = [aws_instance.app_server]
}
