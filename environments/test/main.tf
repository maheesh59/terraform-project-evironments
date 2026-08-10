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
module "eks" {
  source = "../../modules/runtime/eks"

  environment     = var.environment
  cluster_name    = "${var.environment}-eks-cluster-new"
  cluster_version = "1.30"

  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  kms_key_arn = var.kms_key_arn

  node_groups = {
    test_nodes = {
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
      desired_size   = 2
      min_size       = 1
      max_size       = 3

      labels = {
        environment = "test"
      }
    }
  }

  eks_addons = var.eks_addons

  extra_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.project_name
  }
}
