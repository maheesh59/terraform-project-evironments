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

  name_prefix = "${var.project_name}-${var.environment}"

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

  environment     = var.environment
  cluster_name    = "${var.project_name}-${var.environment}-cluster"
  cluster_version = var.kubernetes_version
  vpc_id          = module.vpc.vpc_id

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


  enable_spot_termination_handling = true

  extra_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.project_name
  }
}
