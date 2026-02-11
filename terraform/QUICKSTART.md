# SpendWise Infrastructure - Quick Start Guide

## 🚀 Deploy in 3 Steps

### Step 1: Initialize Terraform
```bash
cd terraform
terraform init
```

### Step 2: Review the Plan
```bash
terraform plan -var-file="dev.tfvars"
```

### Step 3: Deploy
```bash
terraform apply -var-file="dev.tfvars"
```

## 📝 What Gets Created

✅ **VPC** - 10.0.0.0/16  
✅ **Public Subnet** - 10.0.1.0/24  
✅ **Internet Gateway**  
✅ **Route Table** with internet route  
✅ **Security Group** - Ports 22, 80, 5000, 5173  
✅ **EC2 Instance** - t2.micro (Amazon Linux 2023)  
✅ **SSH Key Pair** - Auto-generated and saved to ../ansible/  

## 🔑 SSH Access

After deployment, connect using:
```bash
terraform output -raw ssh_connection_command
# or manually:
ssh -i ../ansible/spendwise-dev-keypair.pem ec2-user@<IP>
```

## 🌍 Environments

| File | Environment | VPC CIDR | Instance |
|------|-------------|----------|----------|
| `dev.tfvars` | Development | 10.0.0.0/16 | t2.micro |
| `stage.tfvars` | Staging | 10.2.0.0/16 | t2.small |
| `prod.tfvars` | Production | 10.1.0.0/16 | t3.small |

## 📊 View Outputs

```bash
# All outputs
terraform output

# Specific output
terraform output instance_public_ip

# Deployment summary
terraform output deployment_info
```

## 🧹 Cleanup

```bash
terraform destroy -var-file="dev.tfvars"
```

## ⚡ Advanced Usage

### Custom Variables
```bash
terraform apply -var="instance_type=t3.small" -var-file="dev.tfvars"
```

### Specific Resource
```bash
terraform apply -target=module.compute -var-file="dev.tfvars"
```

### View State
```bash
terraform show
```

## 🔒 Security Notes

⚠️ **Production**: Update `ssh_allowed_cidr` in prod.tfvars  
⚠️ **Never commit**: .pem files, .tfstate files  
⚠️ **Always encrypt**: State files in S3  

## 📞 Troubleshooting

**Issue**: "No valid credential sources found"  
**Fix**: `aws configure`

**Issue**: "Error acquiring the state lock"  
**Fix**: `terraform force-unlock <LOCK_ID>`

**Issue**: AMI not found in your region  
**Fix**: Update `ami_id` in your .tfvars file

## 📚 Next Steps

1. Deploy infrastructure: `terraform apply -var-file="dev.tfvars"`
2. Note the instance IP from outputs
3. SSH into the instance
4. Run Ansible playbooks from ../ansible/
5. Deploy SpendWise application

---

💡 **Tip**: Always run `terraform plan` before `terraform apply`  
📖 **Docs**: See README.md for detailed documentation
