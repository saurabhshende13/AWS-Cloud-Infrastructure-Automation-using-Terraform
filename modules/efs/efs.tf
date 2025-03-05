locals {
  Name = "SS-Project"
}

# Create KMS Key
resource "aws_kms_key" "my-kms" {
  description = "KMS key for EFS encryption"
  policy      = <<EOF
  {
    "Version": "2012-10-17",
    "Id": "kms-key-policy",
    "Statement": [
      {
        "Sid": "Enable IAM User Permissions",
        "Effect": "Allow",
        "Principal": { "AWS": "arn:aws:iam::${var.account_no}:root" },
        "Action": "kms:*",
        "Resource": "*"
      },
      {
        "Sid": "AllowEFSService",
        "Effect": "Allow",
        "Principal": { "Service": "elasticfilesystem.amazonaws.com" },
        "Action": "kms:Encrypt",
        "Resource": "*"
      }
    ]
  }
  EOF
}

# Create Key Alias
resource "aws_kms_alias" "alias" {
  name          = "alias/kms"
  target_key_id = aws_kms_key.my-kms.key_id
}

# Create Elastic File System
resource "aws_efs_file_system" "my-efs" {
  encrypted  = true
  kms_key_id = aws_kms_key.my-kms.arn
  availability_zone_name = null

  tags = merge(
    var.tags,
    {
      Name = "${local.Name}-file-system"
    }
  )
}

# Set First Mount Target for EFS
resource "aws_efs_mount_target" "subnet-1" {
  file_system_id  = aws_efs_file_system.my-efs.id
  subnet_id       = var.efs-subnet-1
  security_groups = var.efs-sg
}

# Set Second Mount Target for EFS
resource "aws_efs_mount_target" "subnet-2" {
  file_system_id  = aws_efs_file_system.my-efs.id
  subnet_id       = var.efs-subnet-2
  security_groups = var.efs-sg
}

# Create Access Point for WordPress
resource "aws_efs_access_point" "wordpress" {
  file_system_id = aws_efs_file_system.my-efs.id

  posix_user {
    gid = 0
    uid = 0
  }

  root_directory {
    path = "/wordpress"
    creation_info {
      owner_gid   = 0
      owner_uid   = 0
      permissions = 0755
    }
  }
}