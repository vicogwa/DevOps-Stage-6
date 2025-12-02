variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"  
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.medium"  
}

variable "key_name" {
  description = "AWS SSH key pair name"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = "mytodos.mooo.com"
}

variable "ssh_private_key_path" {
  description = "Path to SSH private key for Ansible connection"
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "email_for_alerts" {
  description = "Email address for drift detection alerts"
  type        = string
}

variable "github_repo_url" {
  description = "GitHub repository URL to clone"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into the instance"
  type        = string
  default     = "0.0.0.0/0"  
}
