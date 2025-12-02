output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.todo_app_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.todo_app_server.public_ip
}

output "instance_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.todo_app_server.public_dns
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.todo_app_sg.id
}

output "domain_name" {
  description = "Application domain name"
  value       = var.domain_name
}

output "application_url" {
  description = "Application URL"
  value       = "https://${var.domain_name}"
}
