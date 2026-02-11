# ==============================================
# Security Module Variables
# ==============================================

variable "vpc_id" {
  description = "ID of the VPC where the security group will be created"
  type        = string
}

variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, stage, prod)"
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "CIDR block allowed to access SSH"
  type        = string
}

variable "web_allowed_cidr" {
  description = "CIDR block allowed to access web services"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
