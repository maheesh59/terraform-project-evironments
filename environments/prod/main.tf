# 1. Network Infrastructure
module "vpc" {
  source = "../../modules/foundation/vpc"

  environment          = var.environment
  aws_region           = var.aws_region
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_s3_endpoint   = true
}

# 2. Encryption KMS Key
module "kms" {
  source = "../../modules/foundation/kms"

  alias_name  = "alias/app-${var.environment}"
  description = "KMS Encryption key for ${var.environment} workload"
  tags        = { Environment = var.environment }
}

# 3. S3 Storage Bucket (Prod policies: Lifecycle enabled, deletion protection)
module "s3_assets" {
  source = "../../modules/foundation/s3"

  bucket_name       = "app-assets-${var.environment}-ap-south-1-010160406667"
  enable_versioning = true
  kms_key_arn       = module.kms.key_arn
  force_destroy     = false # Protected against deletion

  enable_lifecycle_rules                        = true
  lifecycle_transition_ia_days                  = 30
  lifecycle_noncurrent_version_expiration_days = 90

  tags = { Environment = var.environment }
}

# 4. Database Secrets
module "secrets" {
  source = "../../modules/foundation/secrets_manager"

  name        = "${var.environment}/app/db-credentials"
  description = "Database credentials for ${var.environment}"
  kms_key_id  = module.kms.key_arn

  secret_key_values = {
    username = "prod_admin"
    password = var.db_password
  }

  tags = { Environment = var.environment }
}

# 5. Application Execution IAM Role
module "iam_role" {
  source = "../../modules/foundation/iam"

  role_name        = "app-execution-role-${var.environment}"
  trusted_services = ["ec2.amazonaws.com"]

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  inline_policies = {
    "s3-access" = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:PutObject"]
        Resource = ["${module.s3_assets.bucket_arn}/*"]
      }]
    })
  }

  tags = { Environment = var.environment }
}
