# ==============================================
# Security Module Outputs
# ==============================================

output "security_group_id" {
  description = "ID of the web server security group"
  value       = aws_security_group.web_server.id
}

output "security_group_name" {
  description = "Name of the web server security group"
  value       = aws_security_group.web_server.name
}

output "security_group_arn" {
  description = "ARN of the web server security group"
  value       = aws_security_group.web_server.arn
}
