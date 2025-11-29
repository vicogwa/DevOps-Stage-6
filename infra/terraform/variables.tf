variable "aws_region" {
  default = "us-east-2"
}

variable "ami_id" {
  description = "AMI ID for Ubuntu 22.04"
  default     = "ami-0a695f0d95cefc163"
}

variable "instance_type" {
  default = "t2.medium"
}

variable "key_name" {
  description = "SSH key pair name"
}