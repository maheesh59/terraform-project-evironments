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

  subnet_tags = var.subnet_tags
}

# ==============================================================================
# 2. VPC Endpoints
# ==============================================================================

module "vpc_endpoints" {
  source = "../../modules/foundation/vpc_endpoints"

  environment = var.environment
  aws_region  = var.aws_region

  vpc_id   = module.vpc.vpc_id
  vpc_cidr = var.vpc_cidr

  private_subnet_ids      = module.vpc.private_subnet_ids
  private_route_table_ids = module.vpc.private_route_table_ids

  enable_s3_endpoint             = true
  enable_dynamodb_endpoint       = true
  enable_ecr_endpoints           = true
  enable_secretsmanager_endpoint = true
  enable_ssm_endpoint            = true

  name_prefix         = "${var.project_name}-${var.environment}"
  security_group_name = "${var.environment}-vpc-vpc-endpoints-sg"

  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.project_name
  }
}


# ==============================================================
# 3. ECR Repositories Configuration
# ==============================================================
module "ecr" {
  source = "../../modules/runtime/ecr"

  environment = var.environment

  repositories = {
    my_prod_ecr = {
      repository_name            = "my-prod-ecr"
      image_tag_mutability       = "IMMUTABLE"
      scan_on_push               = true
      untagged_image_expiry_days = 7
      tagged_image_max_count     = 30
      tagged_prefixes            = ["v", "release"]
    }
  }

  extra_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.project_name
  }
}

# ==============================================================
# 4. Amazon EKS Cluster
# ==============================================================
module "eks" {
  source = "../../modules/runtime/eks"

  environment                = var.environment
  cluster_name               = "${var.project_name}-${var.environment}-cluster"
  cluster_version            = var.kubernetes_version
  cluster_log_retention_days = var.cluster_log_retention_days
  vpc_id                     = module.vpc.vpc_id

  # Passes subnet parameters for modules expecting either naming convention
  subnet_ids         = module.vpc.private_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  node_groups = var.node_groups

  extra_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.project_name
  }
}

# ==============================================================
# 4. Karpenter Autoscaler
# ==============================================================
module "karpenter" {
  source = "../../modules/runtime/eks/karpenter"

  environment = var.environment
  aws_region  = var.aws_region

  cluster_name     = module.eks.cluster_name
  cluster_endpoint = module.eks.cluster_endpoint

  cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id
  oidc_provider_arn                 = module.eks.oidc_provider_arn

  karpenter_version = var.karpenter_version

  enable_spot_termination_handling = true

  sqs_message_retention_seconds = var.sqs_message_retention_seconds

  extra_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.project_name
  }
}

############################################################
# RDS MODULE
############################################################

module "rds" {

  source = "../../modules/runtime/rds"

  ##########################################################
  # PROJECT
  ##########################################################

  project_name = var.project_name
  environment  = var.environment

  ##########################################################
  # TAGS
  ##########################################################

  tags = var.tags

  ##########################################################
  # NETWORK
  ##########################################################

  vpc_id = module.vpc.vpc_id

  subnet_ids = module.vpc.private_subnet_ids

  ##########################################################
  # SECURITY GROUP
  ##########################################################

  allowed_security_group_ids = [
    module.eks.node_security_group_id
  ]

  allowed_cidr_blocks = var.rds.allowed_cidr_blocks

  security_group_description = var.rds.security_group_description

  security_group_ingress_description = var.rds.security_group_ingress_description

  cidr_ingress_description = var.rds.cidr_ingress_description

  ingress_protocol = var.rds.ingress_protocol

  egress_cidr_block = var.rds.egress_cidr

  egress_protocol = var.rds.egress_protocol

  egress_description = var.rds.egress_description

  ##########################################################
  # DATABASE
  ##########################################################

  engine         = var.rds.engine
  engine_version = var.rds.engine_version

  family = var.rds.parameter_group_family

  instance_class = var.rds.instance_class

  db_name  = var.rds.db_name
  username = var.rds.username
  port     = var.rds.port

  ##########################################################
  # PASSWORD
  ##########################################################

  password_length = var.rds.password_length

  password_special = var.rds.password_special

  password_override_special = var.rds.password_special_characters

  ##########################################################
  # STORAGE
  ##########################################################

  allocated_storage     = var.rds.allocated_storage
  max_allocated_storage = var.rds.max_allocated_storage
  storage_type          = var.rds.storage_type

  storage_encrypted = var.rds.storage_encrypted

  ##########################################################
  # KMS
  ##########################################################

  kms_key_arn = null

  secrets_manager_kms_key_arn = null

  kms_deletion_window_in_days = var.rds.kms_deletion_window_in_days

  kms_enable_key_rotation = var.rds.kms_enable_key_rotation


  ##########################################################
  # SECRETS MANAGER
  ##########################################################

  secret_recovery_window_in_days = var.rds.secret_recovery_window_in_days

  ##########################################################
  # NETWORK ACCESS
  ##########################################################

  publicly_accessible = var.rds.publicly_accessible

  multi_az = var.rds.multi_az

  ##########################################################
  # BACKUP
  ##########################################################

  backup_retention_period = var.rds.backup_retention_period

  preferred_backup_window = var.rds.backup_window

  preferred_maintenance_window = var.rds.maintenance_window

  copy_tags_to_snapshot = var.rds.copy_tags_to_snapshot

  ##########################################################
  # DELETION
  ##########################################################

  deletion_protection = var.rds.deletion_protection

  skip_final_snapshot = var.rds.skip_final_snapshot

  ##########################################################
  # MONITORING
  ##########################################################

  monitoring_interval = var.rds.monitoring_interval

  enabled_cloudwatch_logs_exports = var.rds.enabled_cloudwatch_logs_exports

  ##########################################################
  # PARAMETER GROUP
  ##########################################################

  parameters = var.rds.parameters
}
