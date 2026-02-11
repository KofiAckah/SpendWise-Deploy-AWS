# SpendWise Ansible - Quick Reference

## 🚀 Essential Commands

### Initial Setup
```bash
# 1. Navigate to ansible directory
cd ansible/

# 2. Check connectivity
ansible webserver -m ping

# 3. Deploy application
ansible-playbook playbook.yml
```

### Using the Deploy Script
```bash
# Check everything
./deploy.sh check

# Deploy application
./deploy.sh deploy

# Check application status
./deploy.sh status

# View live logs
./deploy.sh logs

# Restart application
./deploy.sh restart

# Get instance info
./deploy.sh info
```

## 🔧 Common Tasks

### Connect via SSH
```bash
ssh -i spendwise-dev-keypair.pem ubuntu@<instance-ip>
```

### Check Docker Status
```bash
ansible webserver -m command -a "docker ps" -b --become-user=ubuntu
```

### Update Application
```bash
# Redeploy with latest code
ansible-playbook playbook.yml --tags "app,deploy"
```

### View Container Logs
```bash
# SSH into server first
ssh -i spendwise-dev-keypair.pem ec2-user@<instance-ip>
cd ~/SpendWise
docker-compose logs -f
```

### Restart Services
```bash
# Restart all containers
ansible webserver -m command -a "docker-compose restart" -b --become-user=ubuntu \
  --extra-vars "chdir=/home/ubuntu/SpendWise"

# Restart specific service
ssh -i spendwise-dev-keypair.pem ubuntu@<instance-ip>
cd ~/SpendWise
docker-compose restart backend
```

## 🌐 Access URLs

Replace `<instance-ip>` with your actual instance IP:

- **Frontend**: http://\<instance-ip\>:5173
- **Backend API**: http://\<instance-ip\>:5000
- **Web (Nginx)**: http://\<instance-ip\>:80

Get instance IP:
```bash
cd ../terraform && terraform output instance_public_ip
```

## 🏷️ Playbook Tags

```bash
# Run specific sections
ansible-playbook playbook.yml --tags "docker"
ansible-playbook playbook.yml --tags "app"
ansible-playbook playbook.yml --tags "deploy"

# Skip sections
ansible-playbook playbook.yml --skip-tags "update"
```

## 🐛 Troubleshooting

### Fix SSH key permissions
```bash
chmod 400 spendwise-dev-keypair.pem
```

### Test SSH Connection
```bash
ssh -i spendwise-dev-keypair.pem ubuntu@<instance-ip> echo "Connected!"
```

### Manual Docker Commands
```bash
# SSH into server
ssh -i spendwise-dev-keypair.pem ubuntu@<instance-ip>

# Check containers
docker ps

# Check logs
cd ~/SpendWise
docker-compose logs

# Restart
docker-compose restart

# Rebuild
docker-compose up -d --build
```

## 📝 Files Overview

| File | Purpose |
|------|---------|
| `playbook.yml` | Main deployment playbook |
| `inventory.ini` | Target hosts configuration |
| `ansible.cfg` | Ansible settings |
| `deploy.sh` | Convenience script for common tasks |
| `spendwise-dev-keypair.pem` | SSH private key (do not commit!) |

## 🔐 Security Reminders

- ⚠️ Never commit `.pem` files
- ⚠️ Always use `chmod 400` on SSH keys
- ⚠️ Keep `inventory.ini` updated with correct IPs
- ⚠️ Use Environment variables for sensitive data

---

**Quick Start**: `./deploy.sh check && ./deploy.sh deploy`
