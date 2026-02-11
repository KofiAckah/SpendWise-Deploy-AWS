# ==============================================
# Security Group Configuration
# ==============================================
resource "aws_security_group" "web_server" {
  name        = "${var.project_name}-${var.environment}-web-sg"
  description = "Security group for ${var.project_name} web server allowing SSH and Web traffic"
  vpc_id      = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-web-sg"
    }
  )
}

# ==============================================
# Ingress Rules - Inbound Traffic
# ==============================================

# SSH Access (Port 22)
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.web_server.id
  description       = "Allow SSH access"

  cidr_ipv4   = var.ssh_allowed_cidr
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"

  tags = {
    Name = "SSH Access"
  }
}

# HTTP Access (Port 80)
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.web_server.id
  description       = "Allow HTTP access"

  cidr_ipv4   = var.web_allowed_cidr
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  tags = {
    Name = "HTTP Access"
  }
}

# Backend API Access (Port 5000)
resource "aws_vpc_security_group_ingress_rule" "backend" {
  security_group_id = aws_security_group.web_server.id
  description       = "Allow Backend API access"

  cidr_ipv4   = var.web_allowed_cidr
  from_port   = 5000
  to_port     = 5000
  ip_protocol = "tcp"

  tags = {
    Name = "Backend API Access"
  }
}

# Frontend Dev Server Access (Port 5173)
resource "aws_vpc_security_group_ingress_rule" "frontend" {
  security_group_id = aws_security_group.web_server.id
  description       = "Allow Frontend Dev Server access"

  cidr_ipv4   = var.web_allowed_cidr
  from_port   = 5173
  to_port     = 5173
  ip_protocol = "tcp"

  tags = {
    Name = "Frontend Dev Server Access"
  }
}

# ==============================================
# Egress Rules - Outbound Traffic
# ==============================================

# Allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.web_server.id
  description       = "Allow all outbound traffic"

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  tags = {
    Name = "All Outbound Traffic"
  }
}
