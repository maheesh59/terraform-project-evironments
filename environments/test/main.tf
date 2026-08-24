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

# Fetch KMS key dynamically by alias (no hardcoded Account ID)
data "aws_kms_key" "state_key" {
  key_id = "alias/global-tfstate-kms"
}

module "eks" {
  source = "../../modules/runtime/eks"

  environment                = var.environment
  cluster_name               = "${var.environment}-eks-cluster-new"
  cluster_version            = var.kubernetes_version
  cluster_log_retention_days = var.cluster_log_retention_days

  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  # Dynamic KMS Key ARN from data source
  kms_key_arn = data.aws_kms_key.state_key.arn

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
