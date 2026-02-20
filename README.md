# SpendWise - Multi-Container Deployment on AWS EC2

A production-ready deployment of the SpendWise expense tracking application on AWS EC2 using Infrastructure as Code (Terraform) and automated deployment (Ansible). The application is fully containerized using Docker Compose with Nginx reverse proxy.

## Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Technology Stack](#technology-stack)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Quick Start Guide](#quick-start-guide)
- [Infrastructure Provisioning](#infrastructure-provisioning)
- [Application Deployment](#application-deployment)
- [Application Architecture](#application-architecture)
- [Accessing the Application](#accessing-the-application)
- [Monitoring and Troubleshooting](#monitoring-and-troubleshooting)
- [Cleanup](#cleanup)

## Project Overview

SpendWise is a full-stack web application for tracking daily expenses, deployed on AWS EC2 infrastructure. The project demonstrates:

- **Infrastructure as Code** using Terraform for AWS resource provisioning
- **Configuration Management** using Ansible for automated deployment
- **Containerization** with Docker and Docker Compose orchestration
- **Reverse Proxy** using Nginx for production traffic routing
- **Multi-tier Architecture** with separate frontend, backend, and database services

### Key Features

- Add and track expenses with amount and category
- View expense list with real-time updates
- Calculate total spending with category filtering
- Delete expenses with confirmation
- Responsive UI with professional design
- Production-ready Docker containerization

## Architecture

### Infrastructure Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    AWS Cloud (VPC)                          │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐ │
│  │              Internet Gateway                          │ │
│  └──────────────────────┬─────────────────────────────────┘ │
│                         │                                    │
│  ┌──────────────────────▼──────────────────────────────────┐ │
│  │         Public Subnet (10.0.1.0/24)                     │ │
│  │                                                          │ │
│  │  ┌────────────────────────────────────────────────────┐ │ │
│  │  │   EC2 Instance (Ubuntu 22.04)                     │ │ │
│  │  │                                                    │ │ │
│  │  │   Docker Containers:                              │ │ │
│  │  │   ┌──────────────────────────────────────────┐   │ │ │
│  │  │   │  Nginx (Port 80)                         │   │ │ │
│  │  │   │  - Serves frontend                       │   │ │ │
│  │  │   │  - Proxies API requests                  │   │ │ │
│  │  │   └──────────────────────────────────────────┘   │ │ │
│  │  │   ┌──────────────────────────────────────────┐   │ │ │
│  │  │   │  Frontend (React + Vite)                 │   │ │ │
│  │  │   │  - Port 5173 (internal)                  │   │ │ │
│  │  │   └──────────────────────────────────────────┘   │ │ │
│  │  │   ┌──────────────────────────────────────────┐   │ │ │
│  │  │   │  Backend (Node.js + Express)             │   │ │ │
│  │  │   │  - Port 5000                             │   │ │ │
│  │  │   │  - REST API                              │   │ │ │
│  │  │   └──────────────────────────────────────────┘   │ │ │
│  │  │   ┌──────────────────────────────────────────┐   │ │ │
│  │  │   │  Database (PostgreSQL 16)                │   │ │ │
│  │  │   │  - Port 5432 (internal)                  │   │ │ │
│  │  │   │  - Persistent volume                     │   │ │ │
│  │  │   └──────────────────────────────────────────┘   │ │ │
│  │  │                                                    │ │ │
│  │  └────────────────────────────────────────────────────┘ │ │
│  │                                                          │ │
│  └──────────────────────────────────────────────────────────┘ │
│                                                             │
└─────────────────────────────────────────────────────────────┘

Security Groups:
- Port 22 (SSH) - Management access
- Port 80 (HTTP) - Web traffic
- Port 5000 (HTTP) - API access
- Port 5173 (HTTP) - Frontend dev server
```

### Application Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      Docker Compose Network                 │
│                                                             │
│  Client Browser                                             │
│       │                                                     │
│       ▼                                                     │
│  ┌─────────┐         ┌──────────────┐                      │
│  │  Nginx  │────────▶│   Frontend   │                      │
│  │  :80    │         │   (React)    │                      │
│  └────┬────┘         │   :5173      │                      │
│       │              └──────────────┘                      │
│       │                                                     │
│       ▼                                                     │
│  ┌──────────────┐    ┌──────────────┐                      │
│  │   Backend    │───▶│  PostgreSQL  │                      │
│  │ (Node.js)    │    │   Database   │                      │
│  │   :5000      │    │    :5432     │                      │
│  └──────────────┘    └──────────────┘                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Technology Stack

### Infrastructure & DevOps

- **Infrastructure as Code**: Terraform v1.0+
- **Configuration Management**: Ansible 2.9+
- **Cloud Provider**: AWS EC2 (Ubuntu 22.04 LTS)
- **Containerization**: Docker & Docker Compose
- **Reverse Proxy**: Nginx

### Application Stack

- **Frontend**: React 19 + Vite
- **Backend**: Node.js 20 + Express
- **Database**: PostgreSQL 16
- **API**: RESTful API with JSON

### Application Repository

The application source code is hosted at: [https://github.com/KofiAckah/SpendWise](https://github.com/KofiAckah/SpendWise)

## Prerequisites

Before you begin, ensure you have the following installed and configured:

### Required Software

- **Terraform** >= 1.0 ([Installation Guide](https://www.terraform.io/downloads.html))
- **Ansible** >= 2.9 ([Installation Guide](https://docs.ansible.com/ansible/latest/installation_guide/index.html))
- **AWS CLI** configured with credentials ([Installation Guide](https://aws.amazon.com/cli/))
- **Git** for cloning repositories

### AWS Requirements

- AWS Account with appropriate permissions
- AWS Access Key ID and Secret Access Key configured
- EC2, VPC, and Security Group permissions

### AWS CLI Configuration

```bash
aws configure
# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Default region: eu-west-1 (or your preferred region)
# Default output format: json
```

## Project Structure

```
SpendWise_Deploy_AWS/
├── terraform/                      # Infrastructure as Code
│   ├── main.tf                    # Root module orchestration
│   ├── provider.tf                # AWS provider configuration
│   ├── variable.tf                # Input variables
│   ├── output.tf                  # Output values
│   ├── dev.tfvars                 # Development environment
│   ├── stage.tfvars               # Staging environment
│   ├── prod.tfvars                # Production environment
│   ├── example.tfvars             # Template for variables
│   │
│   ├── network/                   # Network module
│   │   ├── main.tf               # VPC, Subnet, IGW, Routes
│   │   ├── variable.tf
│   │   └── output.tf
│   │
│   ├── security/                  # Security module
│   │   ├── main.tf               # Security Groups
│   │   ├── variable.tf
│   │   └── output.tf
│   │
│   └── compute/                   # Compute module
│       ├── main.tf               # EC2 Instance, SSH Keys
│       ├── variable.tf
│       └── output.tf
│
├── ansible/                       # Deployment automation
│   ├── playbook.yml              # Main deployment playbook
│   ├── inventory.ini             # Host configuration
│   ├── ansible.cfg               # Ansible settings
│   ├── deploy.sh                 # Deployment script
│   └── README.md                 # Ansible documentation
│
└── README.md                      # This file
```

## Quick Start Guide

### Step 1: Clone the Repository

```bash
git clone <your-deployment-repo-url>
cd SpendWise_Deploy_AWS
```

### Step 2: Provision Infrastructure with Terraform

```bash
cd terraform

# Initialize Terraform
terraform init

# Review the infrastructure plan
terraform plan -var-file="dev.tfvars"

# Apply the infrastructure
terraform apply -var-file="dev.tfvars" -auto-approve

# Save the outputs (instance IP, etc.)
terraform output
```

### Step 3: Deploy Application with Ansible

```bash
cd ../ansible

# Verify connectivity
ansible webserver -m ping

# Deploy the application
ansible-playbook playbook.yml

# Or use the deployment script
./deploy.sh
```

### Step 4: Access the Application

After deployment completes, access the application at:

```
http://<EC2_PUBLIC_IP>
```

The EC2 public IP is displayed in the Terraform outputs.

## Infrastructure Provisioning

### Terraform Configuration

The infrastructure uses a modular Terraform approach with three main modules:

#### 1. Network Module

Creates the networking foundation:

- **VPC**: Virtual Private Cloud (10.0.0.0/16)
- **Public Subnet**: (10.0.1.0/24)
- **Internet Gateway**: For public internet access
- **Route Tables**: Routes traffic to internet gateway

#### 2. Security Module

Configures security and access controls:

- **Security Group** with rules for:
  - SSH (Port 22) - Instance management
  - HTTP (Port 80) - Web traffic via Nginx
  - Backend API (Port 5000) - Node.js API
  - Frontend Dev (Port 5173) - React development server

#### 3. Compute Module

Provisions the EC2 instance:

- **EC2 Instance**: Ubuntu 22.04 LTS (t2.micro)
- **SSH Key Pair**: Auto-generated for secure access
- **Elastic IP**: Static public IP address
- **User Data**: Initial instance configuration

### Terraform Commands Reference

```bash
# Initialize Terraform (download providers)
terraform init

# Format Terraform files
terraform fmt

# Validate configuration
terraform validate

# Plan infrastructure changes
terraform plan -var-file="dev.tfvars"

# Apply infrastructure changes
terraform apply -var-file="dev.tfvars"

# View outputs
terraform output

# View specific output
terraform output instance_public_ip

# Destroy infrastructure
terraform destroy -var-file="dev.tfvars"
```

### Environment-Specific Deployments

Use different tfvars files for different environments:

```bash
# Development
terraform apply -var-file="dev.tfvars"

# Staging
terraform apply -var-file="stage.tfvars"

# Production
terraform apply -var-file="prod.tfvars"
```

### Terraform Outputs

After successful deployment, Terraform provides:

- **instance_public_ip**: Public IP address of EC2 instance
- **instance_id**: EC2 instance identifier
- **vpc_id**: VPC identifier
- **security_group_id**: Security group identifier
- **ssh_private_key**: Path to generated SSH key

## Application Deployment

### Ansible Playbook Overview

The Ansible playbook automates the complete application deployment:

1. **System Update**: Updates all Ubuntu packages
2. **Install Prerequisites**: Docker, Docker Compose, Git
3. **Configure Docker**: Starts service and adds user to docker group
4. **Clone Repository**: Fetches SpendWise application from GitHub
5. **Configure Frontend**: Sets backend API URL to EC2 public IP
6. **Deploy Containers**: Runs docker-compose up with build
7. **Verify Deployment**: Checks running containers

### Deployment Process

#### Manual Deployment

```bash
cd ansible

# Check connectivity
ansible webserver -m ping

# Run the playbook
ansible-playbook playbook.yml

# Run with verbose output
ansible-playbook playbook.yml -vv
```

#### Automated Deployment Script

```bash
cd ansible
./deploy.sh
```

### Deployment Tags

Run specific parts of the deployment using tags:

```bash
# Update system packages only
ansible-playbook playbook.yml --tags "system"

# Install Docker only
ansible-playbook playbook.yml --tags "docker"

# Deploy application only
ansible-playbook playbook.yml --tags "app"

# Configuration only
ansible-playbook playbook.yml --tags "config"

# Verification only
ansible-playbook playbook.yml --tags "verify"
```

### What Gets Deployed

The Ansible playbook deploys the full Docker Compose stack:

#### Docker Compose Services

1. **Frontend Container**
   - React application built with Vite
   - Production build served by Nginx
   - Environment variable for API URL

2. **Backend Container**
   - Node.js Express API server
   - Port 5000 exposed
   - Connected to PostgreSQL database
   - Morgan logging for HTTP requests

3. **Database Container**
   - PostgreSQL 16
   - Persistent volume for data
   - Initialized with schema
   - Category and timestamp indexes

4. **Nginx Container** (Production)
   - Serves frontend static files on port 80
   - Reverse proxy for API requests to backend
   - Optimized for production traffic

### Docker Compose Configuration

The application uses two Docker Compose configurations:

#### Production Mode (docker-compose.yml)

```yaml
# Services orchestrated:
- nginx: Reverse proxy on port 80
- frontend: React production build
- backend: Node.js API on port 5000
- postgres: PostgreSQL database on port 5432
```

Access:
- **Frontend**: http://your-ec2-ip (port 80)
- **Backend API**: http://your-ec2-ip:5000
- **Database**: Internal container network

#### Development Mode (docker-compose.dev.yml)

```yaml
# Services with hot-reload:
- frontend: Vite dev server on port 5173
- backend: Nodemon on port 5000
- postgres: PostgreSQL database
```

Access:
- **Frontend**: http://your-ec2-ip:5173
- **Backend API**: http://your-ec2-ip:5000

### Nginx Configuration

Nginx serves as the production reverse proxy:

- **Frontend**: Serves React build files from `/usr/share/nginx/html`
- **API Proxy**: Routes `/api/*` requests to backend:5000
- **Port**: Listens on port 80 for HTTP traffic
- **Optimization**: Compression, caching headers, and error handling

## Application Architecture

### Database Schema

```sql
CREATE TABLE expenses (
  id SERIAL PRIMARY KEY,
  item_name VARCHAR(255) NOT NULL,
  amount NUMERIC(10, 2) NOT NULL CHECK (amount >= 0),
  category VARCHAR(50) DEFAULT 'Other',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_expenses_created_at ON expenses(created_at DESC);
CREATE INDEX idx_expenses_category ON expenses(category);
```

**Fields:**
- `id`: Auto-incrementing primary key
- `item_name`: Expense description
- `amount`: Expense amount (2 decimal places, must be >= 0)
- `category`: One of: Food, Transport, Entertainment, Shopping, Bills, Other
- `created_at`: Timestamp of creation

**Indexes:**
- `created_at`: For chronological ordering
- `category`: For category filtering

### API Endpoints

#### POST /api/expenses
Add a new expense.

**Request Body:**
```json
{
  "itemName": "Lunch",
  "amount": 25.50,
  "category": "Food"
}
```

**Response (201):**
```json
{
  "message": "Expense added successfully",
  "expense": {
    "id": 1,
    "item_name": "Lunch",
    "amount": "25.50",
    "category": "Food",
    "created_at": "2026-02-19T10:30:00.000Z"
  }
}
```

#### GET /api/expenses
Fetch all expenses, optionally filtered by category.

**Query Parameters:**
- `category` (optional): Food, Transport, Entertainment, Shopping, Bills, Other

**Response (200):**
```json
{
  "expenses": [
    {
      "id": 2,
      "item_name": "Dinner",
      "amount": "35.00",
      "category": "Food",
      "created_at": "2026-02-19T18:00:00.000Z"
    }
  ]
}
```

#### GET /api/expenses/total
Calculate total spending, optionally by category.

**Query Parameters:**
- `category` (optional): Filter by specific category

**Response (200):**
```json
{
  "total": 60.50
}
```

#### DELETE /api/expenses/:id
Delete a specific expense.

**Response (200):**
```json
{
  "message": "Expense deleted successfully"
}
```

#### GET /api/health
Health check endpoint.

**Response (200):**
```json
{
  "status": "ok",
  "message": "SpendWise API is running"
}
```

## Accessing the Application

### Production Access

After successful deployment:

```
Web Application:  http://<EC2_PUBLIC_IP>
Backend API:      http://<EC2_PUBLIC_IP>:5000
API Health:       http://<EC2_PUBLIC_IP>:5000/api/health
```

### Using the Application

1. **Add Expense**: Enter item name, amount, and select category
2. **View Expenses**: See all expenses in chronological order
3. **Filter by Category**: Use the category dropdown to filter
4. **View Total**: See total spending (overall or by category)
5. **Delete Expense**: Click delete button with confirmation

### Security Considerations

**For Production Deployments:**

1. **Restrict SSH Access**: Update security group to allow SSH from your IP only
   ```bash
   # In terraform/dev.tfvars
   ssh_allowed_cidr = "YOUR_IP/32"
   ```

2. **Use HTTPS**: Configure SSL/TLS certificates for encrypted traffic
3. **Database Security**: Use strong passwords, not defaults
4. **API Security**: Implement authentication/authorization
5. **Network Security**: Consider private subnets for database

## Monitoring and Troubleshooting

### Check Deployment Status

```bash
# SSH into EC2 instance
ssh -i ansible/spendwise-dev-keypair.pem ubuntu@<EC2_PUBLIC_IP>

# Check Docker containers
docker ps

# Check container logs
docker logs <container_name>

# Check all logs
docker-compose logs

# Follow logs in real-time
docker-compose logs -f
```

### Verify Services

```bash
# Check Docker service
sudo systemctl status docker

# Check running containers
docker-compose ps

# Restart all services
docker-compose restart

# Rebuild and restart
docker-compose up -d --build
```

### Common Issues

**Issue: Cannot connect to EC2 instance**
- Verify security group allows your IP on port 22
- Check SSH key permissions: `chmod 400 *.pem`
- Verify EC2 instance is running

**Issue: Application not accessible**
- Verify security group allows ports 80, 5000, 5173
- Check containers are running: `docker ps`
- Check container logs: `docker-compose logs`

**Issue: Database connection error**
- Verify PostgreSQL container is running
- Check database credentials in backend .env
- Ensure database is initialized

**Issue: Frontend can't reach backend**
- Verify VITE_API_URL is set to EC2 public IP
- Check nginx proxy configuration
- Ensure backend is listening on 0.0.0.0:5000

### View Application Logs

```bash
# All services
docker-compose logs

# Specific service
docker-compose logs frontend
docker-compose logs backend
docker-compose logs postgres
docker-compose logs nginx

# Last 100 lines
docker-compose logs --tail=100

# Follow logs
docker-compose logs -f backend
```

## Cleanup

### Destroy Infrastructure

When you're done, clean up AWS resources to avoid charges:

```bash
cd terraform

# Destroy all infrastructure
terraform destroy -var-file="dev.tfvars"

# Or with auto-approval
terraform destroy -var-file="dev.tfvars" -auto-approve
```

This will remove all created resources:
- EC2 instance
- Security groups
- Network components (VPC, subnets, IGW, route tables)
- SSH key pairs

### Stop Application (Keep Infrastructure)

If you want to keep the infrastructure but stop the application:

```bash
# SSH to EC2 instance
ssh -i ansible/spendwise-dev-keypair.pem ubuntu@<EC2_PUBLIC_IP>

# Stop containers
cd /home/ubuntu/SpendWise
docker-compose down

# Stop containers and remove volumes (deletes data)
docker-compose down -v
```

## Additional Resources

### Documentation

- **Terraform Docs**: [terraform/README.md](terraform/README.md)
- **Ansible Docs**: [ansible/README.md](ansible/README.md)
- **Application Repo**: [https://github.com/KofiAckah/SpendWise](https://github.com/KofiAckah/SpendWise)

### Useful Commands

```bash
# Terraform
terraform init                          # Initialize
terraform plan -var-file="dev.tfvars"  # Plan changes
terraform apply -var-file="dev.tfvars" # Apply changes
terraform output instance_public_ip     # Get IP
terraform destroy -var-file="dev.tfvars" # Destroy

# Ansible
ansible webserver -m ping              # Test connection
ansible-playbook playbook.yml          # Deploy
ansible-playbook playbook.yml -vv      # Verbose
ansible-playbook playbook.yml --tags "app" # Specific tags

# Docker (on EC2)
docker ps                              # List containers
docker-compose ps                      # Compose status
docker-compose logs                    # View logs
docker-compose restart                 # Restart all
docker-compose down                    # Stop all
docker-compose up -d --build          # Rebuild & start
```

**Project Repository**: [SpendWise Application](https://github.com/KofiAckah/SpendWise)