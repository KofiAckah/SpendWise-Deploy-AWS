# ==============================================
# Root Module Outputs
# ==============================================

# Network Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = module.network.vpc_cidr
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = module.network.public_subnet_id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = module.network.internet_gateway_id
}

# Security Outputs
output "security_group_id" {
  description = "ID of the web server security group"
  value       = module.security.security_group_id
}

output "security_group_name" {
  description = "Name of the web server security group"
  value       = module.security.security_group_name
}

# Compute Outputs
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.compute.instance_id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.compute.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = module.compute.private_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = module.compute.instance_public_dns
}

output "ssh_key_pair_name" {
  description = "Name of the SSH key pair"
  value       = module.compute.key_pair_name
}

output "ssh_private_key_path" {
  description = "Path to the SSH private key file"
  value       = module.compute.private_key_path
}

# Connection Information
output "ssh_connection_command" {
  description = "Command to SSH into the instance"
  value       = "ssh -i ${module.compute.private_key_path} ec2-user@${module.compute.public_ip}"
}

output "deployment_info" {
  description = "Summary of deployed infrastructure"
  value = {
    region            = var.aws_region
    environment       = var.environment
    project           = var.project_name
    vpc_id            = module.network.vpc_id
    subnet_id         = module.network.public_subnet_id
    security_group_id = module.security.security_group_id
    instance_id       = module.compute.instance_id
    public_ip         = module.compute.public_ip
    ssh_key_location  = module.compute.private_key_path
  }
}
