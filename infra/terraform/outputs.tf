output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.todo_app_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.todo_app_server.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.todo_app_server.public_dns
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.todo_app_sg.id
}

output "application_url" {
  description = "URL to access the application"
  value       = "https://${var.domain_name}"
}

output "domain_name" {
  description = "Domain name for the application"
  value       = var.domain_name
}

# SSH Key outputs for CI/CD
output "private_key_pem" {
  description = "Private SSH key for accessing the instance"
  value       = tls_private_key.ssh_key.private_key_pem
  sensitive   = true
}

output "public_key_openssh" {
  description = "Public SSH key"
  value       = tls_private_key.ssh_key.public_key_openssh
}

output "key_pair_name" {
  description = "Name of the AWS key pair"
  value       = aws_key_pair.deployer.key_name
}

# Legacy outputs for backward compatibility (if workflow references these)
output "server_ip" {
  description = "Public IP of the server (legacy)"
  value       = aws_instance.todo_app_server.public_ip
}

output "server_id" {
  description = "ID of the server (legacy)"
  value       = aws_instance.todo_app_server.id
}

output "server_public_ip" {
  description = "Public IP of the server"
  value       = aws_instance.todo_app_server.public_ip
}
