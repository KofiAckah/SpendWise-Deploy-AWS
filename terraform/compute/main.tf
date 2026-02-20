# ==============================================
# IAM Role for EC2 Instance (Parameter Store Access)
# ==============================================
resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-${var.environment}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-ec2-role"
    }
  )
}

# IAM Policy for Parameter Store Access
resource "aws_iam_role_policy" "parameter_store_policy" {
  name = "${var.project_name}-${var.environment}-parameter-store-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ]
        Resource = "arn:aws:ssm:*:*:parameter/${var.project_name}/${var.environment}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt"
        ]
        Resource = "*"
      }
    ]
  })
}

# EC2 Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-${var.environment}-ec2-profile"
  role = aws_iam_role.ec2_role.name

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-ec2-profile"
    }
  )
}

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
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

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
  depends_on = [aws_key_pair.ec2_key_pair, aws_iam_instance_profile.ec2_profile]
}
