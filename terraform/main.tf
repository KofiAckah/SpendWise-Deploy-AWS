# ==============================================
# SpendWise Infrastructure - Root Module
# ==============================================
# This is the main entry point for the SpendWise Terraform infrastructure
# It orchestrates the network, security, and compute modules

# ==============================================
# Network Module
# ==============================================
module "network" {
  source = "./network"

  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
  project_name       = var.project_name
  environment        = var.environment
  common_tags        = var.common_tags
}

# ==============================================
# Security Module
# ==============================================
module "security" {
  source = "./security"

  vpc_id           = module.network.vpc_id
  project_name     = var.project_name
  environment      = var.environment
  ssh_allowed_cidr = var.ssh_allowed_cidr
  web_allowed_cidr = var.web_allowed_cidr
  common_tags      = var.common_tags

  # Ensure security group is created after VPC
  depends_on = [module.network]
}

# ==============================================
# Compute Module
# ==============================================
module "compute" {
  source = "./compute"

  ami_id            = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = module.network.public_subnet_id
  security_group_id = module.security.security_group_id
  project_name      = var.project_name
  environment       = var.environment
  ansible_directory = "${path.module}/../ansible"
  common_tags       = var.common_tags

  # Ensure instance is created after network and security resources
  depends_on = [module.network, module.security]
}
