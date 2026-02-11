# SpendWise Ansible Configuration - Setup Complete! ✅

## 📦 What Was Created

Your Ansible directory now contains everything needed to deploy SpendWise:

```
ansible/
├── inventory.ini           # Host configuration (IP: 108.130.172.153)
├── playbook.yml           # Main deployment playbook (Ubuntu optimized)
├── ansible.cfg            # Ansible configuration
├── deploy.sh              # Convenience deployment script ⭐
├── spendwise-dev-keypair.pem  # SSH private key (from Terraform)
├── README.md              # Complete documentation
├── QUICKSTART.md          # Quick reference guide
└── .gitignore            # Protects sensitive files
```

## ✅ Verified Working

- ✅ SSH connectivity to EC2 instance (108.130.172.153)
- ✅ Ansible can ping the server
- ✅ SSH key permissions set correctly (400)
- ✅ Inventory configured for Ubuntu user
- ✅ Playbook optimized for Ubuntu 22.04 LTS

## 🚀 Deploy Your Application

### Option 1: Using the Deploy Script (Recommended)

```bash
cd ansible/
./deploy.sh deploy
```

### Option 2: Using Ansible Directly

```bash
cd ansible/
ansible-playbook playbook.yml
```

### Option 3: Step by Step Deployment

```bash
# 1. Verify connectivity
./deploy.sh check

# 2. Deploy application
./deploy.sh deploy

# 3. Check status
./deploy.sh status

# 4. View logs
./deploy.sh logs
```

## 🌐 Access Your Application

After deployment completes (takes ~5-10 minutes):

- **Frontend**: http://108.130.172.153:5173
- **Backend API**: http://108.130.172.153:5000
- **Web**: http://108.130.172.153:80 (if configured)

## 📋 What the Deployment Does

1. **Updates System** - Installs latest Ubuntu packages
2. **Installs Docker** - docker.io and docker-compose
3. **Configures Docker** - Adds ubuntu user to docker group
4. **Clones Repository** - https://github.com/KofiAckah/SpendWise
5. **Builds Application** - Runs `docker-compose up -d --build`
6. **Verifies Deployment** - Checks container status

## 🔧 Configuration Details

### Instance Information
- **IP Address**: 108.130.172.153
- **Region**: eu-west-1
- **OS**: Ubuntu 22.04 LTS
- **User**: ubuntu
- **Installation Path**: /home/ubuntu/SpendWise

### Repository
- **URL**: https://github.com/KofiAckah/SpendWise
- **Branch**: main

### Ports Opened
- **22** - SSH
- **80** - HTTP
- **5000** - Backend API
- **5173** - Frontend (Vite)

## 🛠️ Common Commands

### Check Application Status
```bash
./deploy.sh status
```

### View Live Logs
```bash
./deploy.sh logs
```

### Restart Application
```bash
./deploy.sh restart
```

### SSH into Server
```bash
ssh -i spendwise-dev-keypair.pem ubuntu@108.130.172.153
```

### Manual Docker Commands
```bash
# SSH in first
ssh -i spendwise-dev-keypair.pem ubuntu@108.130.172.153

# Check containers
docker ps

# View logs
cd ~/SpendWise
docker-compose logs -f

# Restart services
docker-compose restart

# Rebuild
docker-compose up -d --build
```

## 🔄 Updating the Application

To pull latest code and redeploy:

```bash
# Option 1: Full redeployment
./deploy.sh deploy

# Option 2: Just update app (skip system updates)
ansible-playbook playbook.yml --tags "app,deploy"
```

## 🐛 Troubleshooting

### Connection Issues

```bash
# Test SSH connectivity
ssh -i spendwise-dev-keypair.pem ubuntu@108.130.172.153 echo "Connected!"

# Test Ansible ping
ansible webserver -m ping
```

### Check Logs

```bash
# Ansible logs
cat ansible.log

# Application logs (on server)
ssh -i spendwise-dev-keypair.pem ubuntu@108.130.172.153
cd ~/SpendWise
docker-compose logs
```

### Permission Errors

```bash
# Fix SSH key permissions
chmod 400 spendwise-dev-keypair.pem

# Re-run docker group setup
ansible-playbook playbook.yml --tags "docker,permissions"
```

## 📚 Documentation

- **README.md** - Comprehensive guide with all commands
- **QUICKSTART.md** - Quick reference for common tasks
- **deploy.sh help** - Built-in help for the deploy script

## 🎯 Next Steps

1. **Deploy the Application**
   ```bash
   ./deploy.sh deploy
   ```

2. **Verify Deployment**
   ```bash
   ./deploy.sh status
   ```

3. **Access Frontend**
   - Open browser to: http://108.130.172.153:5173

4. **Test Backend API**
   ```bash
   curl http://108.130.172.153:5000/health
   ```

5. **Monitor Logs**
   ```bash
   ./deploy.sh logs
   ```

## ⚠️ Important Notes

1. **SSH Key**: Never commit `spendwise-dev-keypair.pem` to git (protected by .gitignore)
2. **IP Address**: If you recreate infrastructure, update IP in `inventory.ini`
3. **Region**: Currently deployed in eu-west-1
4. **User**: Ubuntu (not ec2-user like Amazon Linux)
5. **Docker**: All containers run as ubuntu user

## 🔐 Security

- SSH key has correct permissions (400)
- Security group allows ports: 22, 80, 5000, 5173
- All Docker commands run as non-root ubuntu user
- Sensitive files protected by .gitignore

## 📞 Need Help?

```bash
# Show all deploy.sh commands
./deploy.sh help

# Check Ansible version
ansible --version

# Verify inventory
ansible-inventory --list

# Test specific playbook tags
ansible-playbook playbook.yml --list-tags
```

---

**Status**: ✅ Ready to Deploy  
**Instance**: 108.130.172.153  
**Repository**: https://github.com/KofiAckah/SpendWise  
**Action**: Run `./deploy.sh deploy` to start deployment

🚀 **You're all set! Run the deploy command to launch your SpendWise application!**
