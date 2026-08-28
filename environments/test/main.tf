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

  name_prefix = "${var.environment}-vpc"

  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.project_name
  }
}

# ==============================================================
# 3. Container Registry (Test ECR Repository)
# ==============================================================
module "ecr" {
  source = "../../modules/runtime/ecr"

  environment = var.environment

  repositories = {
    my_test_ecr = {
      repository_name            = "my-test-ecr"
      image_tag_mutability       = var.ecr_frontend_mutability
      scan_on_push               = true
      untagged_image_expiry_days = var.ecr_untagged_expiry_days
      tagged_image_max_count     = var.ecr_tagged_max_count
      tagged_prefixes            = var.ecr_tagged_prefixes
    }
  }

  extra_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.project_name
  }
}

# ==============================================================
# 4. EKS Cluster Configuration
# ==============================================================

data "aws_caller_identity" "current" {}

module "eks" {
  source = "../../modules/runtime/eks"

  environment                = var.environment
  cluster_name               = "${var.environment}-eks-cluster-new"
  cluster_version            = var.kubernetes_version
  cluster_log_retention_days = var.cluster_log_retention_days

  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids


  node_groups = var.node_groups

  eks_addons = {
    aws-ebs-csi-driver = {
      version = var.eks_addons["aws-ebs-csi-driver"].version

      service_account_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.eks_addons["aws-ebs-csi-driver"].service_account_role_name}"
    }

    vpc-cni = {
      version = var.eks_addons["vpc-cni"].version
    }

    coredns = {
      version = var.eks_addons["coredns"].version
    }

    kube-proxy = {}
  }

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
  # PROJECT & TAGS
  ##########################################################
  project_name = var.project_name
  environment  = var.environment
  tags         = var.tags

  ##########################################################
  # NETWORK & SECURITY
  ##########################################################
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids

  allowed_security_group_ids = [
  module.eks.node_security_group_id,
  "sg-0991f5e5ec131b81a"
]

  allowed_cidr_blocks                = var.rds.allowed_cidr_blocks
  security_group_description         = var.rds.security_group_description
  security_group_ingress_description = var.rds.security_group_ingress_description
  cidr_ingress_description           = var.rds.cidr_ingress_description
  ingress_protocol                   = var.rds.ingress_protocol
  egress_cidr_block                  = var.rds.egress_cidr
  egress_protocol                    = var.rds.egress_protocol
  egress_description                 = var.rds.egress_description

  ##########################################################
  # DATABASE & AUTHENTICATION
  ##########################################################
  engine         = var.rds.engine
  engine_version = var.rds.engine_version
  family         = var.rds.parameter_group_family
  instance_class = var.rds.instance_class

  db_name  = var.rds.db_name
  username = var.rds.username
  port     = var.rds.port
  password = var.rds.password

  ##########################################################
  # STORAGE
  ##########################################################
  allocated_storage     = var.rds.allocated_storage
  max_allocated_storage = var.rds.max_allocated_storage
  storage_type          = var.rds.storage_type
  storage_encrypted     = var.rds.storage_encrypted

  ##########################################################
  # KMS & SECRETS MANAGER
  ##########################################################
  kms_key_arn                    = var.rds.kms_key_arn
  secrets_manager_kms_key_arn    = var.rds.secrets_manager_kms_key_arn
  kms_deletion_window_in_days    = var.rds.kms_deletion_window_in_days
  kms_enable_key_rotation        = var.rds.kms_enable_key_rotation
  secret_recovery_window_in_days = var.rds.secret_recovery_window_in_days

  ##########################################################
  # NETWORK ACCESS & BACKUPS
  ##########################################################
  publicly_accessible          = var.rds.publicly_accessible
  multi_az                     = var.rds.multi_az
  backup_retention_period      = var.rds.backup_retention_period
  preferred_backup_window      = var.rds.backup_window
  preferred_maintenance_window = var.rds.maintenance_window
  copy_tags_to_snapshot        = var.rds.copy_tags_to_snapshot

  ##########################################################
  # DELETION & MONITORING
  ##########################################################
  deletion_protection             = var.rds.deletion_protection
  skip_final_snapshot             = var.rds.skip_final_snapshot
  monitoring_interval             = var.rds.monitoring_interval
  enabled_cloudwatch_logs_exports = var.rds.enabled_cloudwatch_logs_exports
  parameters                      = var.rds.parameters
}

# ==============================================================================
# AWS Load Balancer Controller
# Test Environment
# Location: environments/test/main.tf
# ==============================================================================

module "load_balancer_controller" {
  source = "../../modules/runtime/load-balancer-controller"

  # --------------------------------------------------------------------------
  # AWS
  # --------------------------------------------------------------------------

  aws_region = var.aws_region

  # --------------------------------------------------------------------------
  # Project
  # --------------------------------------------------------------------------

  project_name = var.project_name

  environment = var.environment

  # --------------------------------------------------------------------------
  # VPC
  # --------------------------------------------------------------------------

  vpc_id = module.vpc.vpc_id

  # --------------------------------------------------------------------------
  # EKS
  # --------------------------------------------------------------------------

  cluster_name = module.eks.cluster_name

  # --------------------------------------------------------------------------
  # OIDC / IRSA
  # --------------------------------------------------------------------------

  oidc_provider_arn = module.eks.oidc_provider_arn

  oidc_provider_url = module.eks.oidc_provider_url

  # --------------------------------------------------------------------------
  # Controller
  # --------------------------------------------------------------------------

  enable_aws_load_balancer_controller = (
    var.enable_aws_load_balancer_controller
  )

  lb_controller_replica_count = (
    var.lb_controller_replica_count
  )

  lb_controller_chart_version = (
    var.lb_controller_chart_version
  )

  # --------------------------------------------------------------------------
  # WAF / Shield
  # --------------------------------------------------------------------------

  enable_waf = var.enable_waf

  enable_wafv2 = var.enable_wafv2

  enable_shield = var.enable_shield

  # --------------------------------------------------------------------------
  # Kubernetes
  # --------------------------------------------------------------------------

  lb_controller_namespace = "kube-system"

  lb_controller_service_account = "aws-load-balancer-controller"

  # --------------------------------------------------------------------------
  # Tags
  # --------------------------------------------------------------------------

  additional_tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}




