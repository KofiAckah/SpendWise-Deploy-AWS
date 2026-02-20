# AWS Provider Configuration Variables
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-west-1"
}

# Project Configuration
variable "project_name" {
  description = "Name of the project to be used for resource naming and tagging"
  type        = string
  default     = "spendwise"
}

variable "environment" {
  description = "Environment name (dev, stage, prod)"
  type        = string
  default     = "dev"
}

# Network Configuration
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
  default     = "eu-west-1a"
}

# Compute Configuration
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for EC2 instance (Amazon Linux 2023)"
  type        = string
  default     = "ami-0d64bb532e0502c46" # Amazon Linux 2023 in eu-west-1
}

# Security Configuration
variable "ssh_allowed_cidr" {
  description = "CIDR block allowed to access SSH"
  type        = string
  default     = "0.0.0.0/0"
}

variable "web_allowed_cidr" {
  description = "CIDR block allowed to access web services"
  type        = string
  default     = "0.0.0.0/0"
}

# Tags
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Project   = "SpendWise"
    ManagedBy = "Terraform"
  }
}

# ==============================================
# Application Configuration
# ==============================================

variable "postgres_db" {
  description = "PostgreSQL database name"
  type        = string
  default     = "spendwise"
}

variable "postgres_user" {
  description = "PostgreSQL database user"
  type        = string
  sensitive   = true
}

variable "postgres_password" {
  description = "PostgreSQL database password"
  type        = string
  sensitive   = true
}

variable "backend_port" {
  description = "Backend API server port"
  type        = string
  default     = "5000"
}

variable "db_host" {
  description = "Database host (use 'postgres' for Docker)"
  type        = string
  default     = "postgres"
}

variable "db_port" {
  description = "Database port"
  type        = string
  default     = "5432"
}

variable "compose_project_name" {
  description = "Docker Compose project name"
  type        = string
  default     = "spendwise"
}

variable "frontend_port" {
  description = "Frontend application port"
  type        = string
  default     = "5173"
}