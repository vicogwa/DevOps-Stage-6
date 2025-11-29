output "server_ip" {
  value = aws_instance.app_server.public_ip
}

output "server_id" {
  value = aws_instance.app_server.id
}