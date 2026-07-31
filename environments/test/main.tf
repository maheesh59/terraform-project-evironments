# ==============================================================
# 1. Network Infrastructure (VPC)
# ==============================================================
module "vpc" {
  source = "../../modules/foundation/vpc"

  environment          = var.environment
  aws_region           = var.aws_region
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_azs    = var.public_subnet_azs
  private_subnet_azs   = var.private_subnet_azs
  enable_s3_endpoint   = true
}

# ==============================================================
# 2. Key Management Service (KMS)
# ==============================================================
module "kms" {
  source = "../../modules/foundation/kms"

  environment = var.environment
  project     = var.project_name
}

# ==============================================================
# 3. Storage Infrastructure (S3 Multi-Bucket Fleet)
# ==============================================================
module "s3_assets" {
  source = "../../modules/foundation/s3"

  buckets = {
    assets = {
      bucket_name       = "app-assets-${var.environment}-010160406667"
      enable_versioning = true
      kms_key_arn       = module.kms.key_arn
    }
    logs = {
      bucket_name                  = "app-logs-${var.environment}-010160406667"
      enable_versioning            = false
      enable_lifecycle_rules       = true
      lifecycle_transition_ia_days = 30
    }
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ==============================================================
# 4. Identity & Access Management (Data-Driven IAM)
# ==============================================================
module "iam" {
  source = "../../modules/foundation/iam"

  project_name = var.project_name
  environment  = var.environment
  owner        = var.owner

  # Custom Managed Policies
  policies = {
    "s3-app-access" = {
      description = "Access policy for app assets S3 bucket"
      policy_json = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "s3:GetObject",
              "s3:PutObject",
              "s3:ListBucket"
            ]
            Resource = [
              module.s3_assets.bucket_arns["assets"],
              "${module.s3_assets.bucket_arns["assets"]}/*"
            ]
          }
        ]
      })
    }
  }

  # Standard Service Execution Roles
  roles = {
    "ec2-app-role" = {
      principal_type        = "Service"
      principal_identifiers = ["ec2.amazonaws.com"]
    }
  }

  # Role Policy Attachments
  role_policy_attachments = {
    "ec2-s3-attach" = {
      role_key   = "ec2-app-role"
      policy_key = "s3-app-access"
    }
  }
}

# ==============================================================
# 5. Secrets Manager
# ==============================================================
module "secrets_manager" {
  source = "../../modules/foundation/secrets_manager"

  secrets = {
    db_credentials = {
      name        = "${var.environment}/app/db"
      description = "Master database credentials"
      kms_key_id  = module.kms.key_arn
      secret_key_values = {
        username = "admin"
        password = var.db_password
      }
    }
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
