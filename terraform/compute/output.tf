# ==============================================
# Compute Module Outputs
# ==============================================

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web_server.id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}

output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.web_server.private_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.web_server.public_dns
}

output "key_pair_name" {
  description = "Name of the SSH key pair"
  value       = aws_key_pair.ec2_key_pair.key_name
}

output "private_key_path" {
  description = "Path to the private key file"
  value       = local_file.private_key.filename
}

output "private_key_pem" {
  description = "Private key in PEM format"
  value       = tls_private_key.ec2_key.private_key_pem
  sensitive   = true
}
