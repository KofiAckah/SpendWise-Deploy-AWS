# ==============================================
# TLS Private Key Generation
# ==============================================
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# ==============================================
# AWS Key Pair
# ==============================================
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "${var.project_name}-${var.environment}-keypair"
  public_key = tls_private_key.ec2_key.public_key_openssh

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-keypair"
    }
  )
}

# ==============================================
# Save Private Key to Ansible Directory
# ==============================================
resource "local_file" "private_key" {
  content         = tls_private_key.ec2_key.private_key_pem
  filename        = "${var.ansible_directory}/${var.project_name}-${var.environment}-keypair.pem"
  file_permission = "0400"
}

# ==============================================
# EC2 Instance
# ==============================================
resource "aws_instance" "web_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = aws_key_pair.ec2_key_pair.key_name

  # Root volume configuration
  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    delete_on_termination = true
    encrypted             = true

    tags = merge(
      var.common_tags,
      {
        Name = "${var.project_name}-${var.environment}-root-volume"
      }
    )
  }

  # User data for initial setup (optional)
  user_data = var.user_data_script

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.project_name}-${var.environment}-web-server"
      Environment = var.environment
      Role        = "WebServer"
    }
  )

  # Ensure the instance is created after the key pair
  depends_on = [aws_key_pair.ec2_key_pair]
}
