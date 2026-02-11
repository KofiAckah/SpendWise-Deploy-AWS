# SpendWise Terraform Infrastructure

Modular Terraform infrastructure for deploying the SpendWise application on AWS.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Quick Start](#quick-start)
- [Module Documentation](#module-documentation)
- [Usage](#usage)
- [Outputs](#outputs)
- [Cleanup](#cleanup)

## 🎯 Overview

This Terraform project provisions a complete AWS infrastructure for the SpendWise application using a modular approach. It creates:

- **Network Layer**: VPC, Public Subnet, Internet Gateway, Route Tables
- **Security Layer**: Security Groups with SSH and Web access
- **Compute Layer**: EC2 instance with auto-generated SSH keys

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────┐
│                 AWS Cloud (VPC)                     │
│                                                     │
│  ┌───────────────────────────────────────────────┐ │
│  │         Internet Gateway                      │ │
│  └──────────────────┬────────────────────────────┘ │
│                     │                               │
│  ┌──────────────────▼────────────────────────────┐ │
│  │         Public Subnet (10.0.1.0/24)          │ │
│  │                                               │ │
│  │  ┌─────────────────────────────────────────┐ │ │
│  │  │   EC2 Instance (t2.micro)               │ │ │
│  │  │                                         │ │ │
│  │  │   - SpendWise Application              │ │ │
│  │  │   - Ports: 22, 80, 5000, 5173          │ │ │
│  │  │   - Auto-generated SSH Key             │ │ │
│  │  └─────────────────────────────────────────┘ │ │
│  │                                               │ │
│  └───────────────────────────────────────────────┘ │
│                                                     │
└─────────────────────────────────────────────────────┘
```

## 📦 Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with credentials
- AWS Account with appropriate permissions

## 📁 Project Structure

```
terraform/
├── main.tf                 # Root module - orchestrates all modules
├── provider.tf             # AWS provider configuration
├── variable.tf             # Input variables
├── output.tf               # Output values
├── dev.tfvars             # Development environment variables
├── stage.tfvars           # Staging environment variables
├── prod.tfvars            # Production environment variables
├── example.tfvars         # Example/template variables file
├── .gitignore             # Git ignore rules
├── README.md              # This file
│
├── network/               # Network module
│   ├── main.tf           # VPC, Subnet, IGW, Route Table
│   ├── variable.tf       # Module variables
│   └── output.tf         # Module outputs
│
├── security/             # Security module
│   ├── main.tf          # Security Groups
│   ├── variable.tf      # Module variables
│   └── output.tf        # Module outputs
│
└── compute/              # Compute module
    ├── main.tf          # EC2 Instance, SSH Keys
    ├── variable.tf      # Module variables
    └── output.tf        # Module outputs
```

## 🚀 Quick Start

### 1. Configure AWS Credentials

```bash
aws configure
```

### 2. Initialize Terraform

```bash
cd terraform
terraform init
```

### 3. Review the Plan

```bash
# For development environment
terraform plan -var-file="dev.tfvars"
```

### 4. Deploy Infrastructure

```bash
terraform apply -var-file="dev.tfvars"
```

### 5. Get Connection Details

```bash
terraform output ssh_connection_command
```

## 📚 Module Documentation

### Network Module

Creates the foundational network infrastructure:

- **VPC**: Custom VPC with DNS support
- **Public Subnet**: Internet-accessible subnet
- **Internet Gateway**: Enables internet access
- **Route Table**: Routes traffic through IGW

**Outputs**: `vpc_id`, `public_subnet_id`, `internet_gateway_id`

### Security Module

Manages security groups and firewall rules:

- **SSH Access**: Port 22
- **HTTP**: Port 80
- **Backend API**: Port 5000
- **Frontend Dev Server**: Port 5173
- **Outbound**: All traffic allowed

**Outputs**: `security_group_id`, `security_group_name`

### Compute Module

Provisions EC2 instances and SSH keys:

- **TLS Key Generation**: Auto-generates RSA 4096-bit key
- **AWS Key Pair**: Creates key pair from generated public key
- **EC2 Instance**: Launches instance in public subnet
- **Private Key Storage**: Saves key to `../ansible/` directory

**Outputs**: `instance_id`, `public_ip`, `private_key_path`

## 💡 Usage

### Deploy to Different Environments

```bash
# Development
terraform apply -var-file="dev.tfvars"

# Staging
terraform apply -var-file="stage.tfvars"

# Production
terraform apply -var-file="prod.tfvars"
```

### SSH into Instance

```bash
# Get the SSH command
terraform output -raw ssh_connection_command

# Or manually
ssh -i ../ansible/spendwise-dev-keypair.pem ec2-user@<instance-ip>
```

### View All Outputs

```bash
terraform output
```

### View Specific Output

```bash
terraform output instance_public_ip
```

## 📤 Outputs

| Output Name | Description |
|-------------|-------------|
| `vpc_id` | ID of the created VPC |
| `public_subnet_id` | ID of the public subnet |
| `security_group_id` | ID of the web server security group |
| `instance_id` | ID of the EC2 instance |
| `instance_public_ip` | Public IP address of the instance |
| `instance_public_dns` | Public DNS name of the instance |
| `ssh_key_pair_name` | Name of the SSH key pair |
| `ssh_private_key_path` | Path to the private key file |
| `ssh_connection_command` | Ready-to-use SSH command |
| `deployment_info` | Summary of all deployed resources |

## 🔧 Customization

### Update Variables

Edit the appropriate `.tfvars` file or create your own:

```hcl
# custom.tfvars
aws_region = "us-east-1"
instance_type = "t3.small"
vpc_cidr = "172.16.0.0/16"
```

Then apply:

```bash
terraform apply -var-file="custom.tfvars"
```

### Modify Modules

Each module can be customized independently:

- **Network**: Adjust CIDR blocks, add subnets
- **Security**: Add/remove security group rules  
- **Compute**: Change instance type, AMI, volume size

## 🧹 Cleanup

To destroy all resources:

```bash
terraform destroy -var-file="dev.tfvars"
```

⚠️ **Warning**: This will delete all resources and cannot be undone!

## 🔒 Security Best Practices

1. **SSH Access**: Restrict `ssh_allowed_cidr` to your IP range in production
2. **Private Keys**: Never commit `.pem` files to version control
3. **Secrets**: Use AWS Secrets Manager or Parameter Store for sensitive data
4. **Tagging**: Apply consistent tags for cost tracking and resource management
5. **State Files**: Store state files in S3 with encryption and versioning

## 📝 Notes

- The private SSH key is automatically saved to `../ansible/` directory
- All resources are tagged with project name and environment
- Instance has a 20GB encrypted root volume
- Security groups use the latest AWS VPC security group rule format

## 🤝 Contributing

1. Create feature branch
2. Make changes
3. Test with `terraform plan`
4. Submit pull request

## 📄 License

This project is for educational purposes as part of the SpendWise deployment infrastructure.

---

**Created for**: SpendWise Project  
**Managed by**: Terraform  
**Infrastructure**: AWS Cloud
