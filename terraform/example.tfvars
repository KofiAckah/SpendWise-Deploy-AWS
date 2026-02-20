# ==============================================
# SpendWise Terraform Variables Example
# ==============================================
# This file serves as a template for creating environment-specific tfvars files
# Copy this file and fill in your specific values
#
# Usage:
#   terraform plan -var-file="dev.tfvars"
#   terraform apply -var-file="dev.tfvars"
#
# Available environment files:
#   - dev.tfvars   : Development environment
#   - stage.tfvars : Staging environment
#   - prod.tfvars  : Production environment

# ==============================================
# AWS Configuration
# ==============================================
aws_region = "eu-west-1" # Change to your preferred AWS region

# ==============================================
# Project Configuration
# ==============================================
project_name = "spendwise"
environment  = "dev" # Options: dev, stage, prod

# ==============================================
# Network Configuration
# ==============================================
vpc_cidr           = "10.0.0.0/16" # VPC CIDR block
public_subnet_cidr = "10.0.1.0/24" # Public subnet CIDR
availability_zone  = "eu-west-1a"  # Availability zone for resources

# ==============================================
# Compute Configuration
# ==============================================
instance_type = "t2.micro"              # EC2 instance type
ami_id        = "ami-0d64bb532e0502c46" # Amazon Linux 2023 AMI ID

# Note: Update AMI ID based on your region
# To find the latest Amazon Linux 2023 AMI:
#   aws ec2 describe-images \
#     --owners amazon \
#     --filters "Name=name,Values=al2023-ami-*" \
#     --query 'sort_by(Images, &CreationDate)[-1].[ImageId]' \
#     --output text

# ==============================================
# Security Configuration
# ==============================================
ssh_allowed_cidr = "0.0.0.0/0" # CIDR block for SSH access (restrict in production!)
web_allowed_cidr = "0.0.0.0/0" # CIDR block for web access

# SECURITY WARNING:
# For production environments, replace 0.0.0.0/0 with your specific IP ranges
# Example: ssh_allowed_cidr = "203.0.113.0/24"

# ==============================================
# Application Configuration
# ==============================================
# Database Configuration
postgres_db       = "spendwise"
postgres_user     = "spendwise_user"     # Change this for your environment
postgres_password = "CHANGE_ME_STRONG_PASSWORD" # IMPORTANT: Use strong password!

# Backend Configuration
backend_port         = "5000"
db_host              = "postgres"  # Docker service name
db_port              = "5432"
compose_project_name = "spendwise"
frontend_port        = "5173"

# ==============================================
# Resource Tags
# ==============================================
common_tags = {
  Project     = "SpendWise"
  Environment = "Development"
  ManagedBy   = "Terraform"
  Owner       = "DevOps Team"
  CostCenter  = "Engineering"
}
