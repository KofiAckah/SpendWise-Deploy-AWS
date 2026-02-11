#!/bin/bash
# ==============================================
# SpendWise Ansible Deployment Script
# ==============================================
# This script provides a convenient way to test and deploy the SpendWise application

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Functions
print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

# Check prerequisites
check_prerequisites() {
    print_header "Checking Prerequisites"
    
    # Check Ansible
    if command -v ansible &> /dev/null; then
        print_success "Ansible is installed: $(ansible --version | head -1)"
    else
        print_error "Ansible is not installed"
        echo "Install with: sudo dnf install ansible -y"
        exit 1
    fi
    
    # Check key file
    if [ -f "spendwise-dev-keypair.pem" ]; then
        print_success "SSH key found: spendwise-dev-keypair.pem"
        
        # Check key permissions
        PERMS=$(stat -c "%a" spendwise-dev-keypair.pem)
        if [ "$PERMS" != "400" ]; then
            print_info "Fixing key permissions..."
            chmod 400 spendwise-dev-keypair.pem
            print_success "Key permissions set to 400"
        fi
    else
        print_error "SSH key not found: spendwise-dev-keypair.pem"
        echo "Run Terraform first to generate the key"
        exit 1
    fi
    
    # Check inventory file
    if [ -f "inventory.ini" ]; then
        print_success "Inventory file found"
    else
        print_error "Inventory file not found: inventory.ini"
        exit 1
    fi
    
    echo ""
}

# Test connectivity
test_connection() {
    print_header "Testing SSH Connectivity"
    
    if ansible webserver -m ping; then
        print_success "Successfully connected to all hosts!"
    else
        print_error "Failed to connect to hosts"
        print_info "Check your inventory.ini and ensure the instance is running"
        exit 1
    fi
    
    echo ""
}

# Get instance info
get_instance_info() {
    print_header "Instance Information"
    
    # Get IP from inventory
    INSTANCE_IP=$(grep -A1 "\[webserver\]" inventory.ini | tail -1 | awk '{print $2}' | cut -d'=' -f2)
    
    echo -e "${BLUE}Instance IP:${NC} $INSTANCE_IP"
    echo -e "${BLUE}SSH Command:${NC} ssh -i spendwise-dev-keypair.pem ubuntu@$INSTANCE_IP"
    echo -e "${BLUE}Frontend URL:${NC} http://$INSTANCE_IP:5173"
    echo -e "${BLUE}Backend API:${NC} http://$INSTANCE_IP:5000"
    echo ""
}

# Deploy application
deploy_app() {
    print_header "Deploying SpendWise Application"
    
    if [ "$1" == "-v" ]; then
        ansible-playbook playbook.yml -v
    else
        ansible-playbook playbook.yml
    fi
    
    if [ $? -eq 0 ]; then
        print_success "Deployment completed successfully!"
        echo ""
        get_instance_info
    else
        print_error "Deployment failed!"
        exit 1
    fi
}

# Check application status
check_status() {
    print_header "Checking Application Status"
    
    echo "Docker containers:"
    ansible webserver -m command -a "docker ps" -b --become-user=ubuntu
    
    echo ""
    echo "Docker Compose services:"
    ansible webserver -m command -a "docker-compose ps" -b --become-user=ubuntu \
        --extra-vars "chdir=/home/ubuntu/SpendWise" 2>/dev/null || echo "Could not get compose status"
    
    echo ""
}

# View logs
view_logs() {
    print_header "Application Logs"
    
    INSTANCE_IP=$(grep -A1 "\[webserver\]" inventory.ini | tail -1 | awk '{print $2}' | cut -d'=' -f2)
    
    print_info "Connecting to view logs (Ctrl+C to exit)..."
    ssh -i spendwise-dev-keypair.pem ubuntu@$INSTANCE_IP "cd ~/SpendWise && docker-compose logs -f"
}

# Restart application
restart_app() {
    print_header "Restarting Application"
    
    ansible webserver -m command -a "docker-compose restart" -b --become-user=ubuntu \
        --extra-vars "chdir=/home/ubuntu/SpendWise"
    
    print_success "Application restarted!"
}

# Stop application
stop_app() {
    print_header "Stopping Application"
    
    ansible webserver -m command -a "docker-compose down" -b --become-user=ubuntu \
        --extra-vars "chdir=/home/ubuntu/SpendWise"
    
    print_success "Application stopped!"
}

# Show usage
show_usage() {
    cat << EOF
${BLUE}SpendWise Ansible Deployment Tool${NC}

Usage: $0 [COMMAND] [OPTIONS]

Commands:
    check       Check prerequisites and connectivity
    deploy      Deploy the application
    deploy -v   Deploy with verbose output
    status      Check application status
    logs        View application logs (live)
    restart     Restart the application
    stop        Stop the application
    info        Show instance information
    help        Show this help message

Examples:
    $0 check           # Verify everything is ready
    $0 deploy          # Deploy the application
    $0 status          # Check if app is running
    $0 logs            # View live logs

EOF
}

# Main script
main() {
    case "${1:-}" in
        check)
            check_prerequisites
            test_connection
            get_instance_info
            ;;
        deploy)
            check_prerequisites
            test_connection
            deploy_app "${2:-}"
            ;;
        status)
            check_status
            ;;
        logs)
            view_logs
            ;;
        restart)
            restart_app
            ;;
        stop)
            stop_app
            ;;
        info)
            get_instance_info
            ;;
        help|--help|-h)
            show_usage
            ;;
        *)
            show_usage
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
