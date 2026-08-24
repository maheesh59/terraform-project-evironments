# ==============================================================
# Global Configuration (ap-south-1)
# ==============================================================
aws_region   = "ap-south-1"
environment  = "test"
project_name = "foundation"

# ==============================================================
# VPC Configuration
# ==============================================================
vpc_cidr = "10.10.0.0/16"

# 2 Public Subnets
public_subnet_cidrs = ["10.10.1.0/24", "10.10.2.0/24"]
public_subnet_azs   = ["ap-south-1a", "ap-south-1b"]

# 2 private subnets
private_subnet_cidrs = ["10.10.11.0/24", "10.10.12.0/24"]
private_subnet_azs   = ["ap-south-1b", "ap-south-1a"]

# ==============================================================
# Container Registry (ECR) Overrides (Optional)
# ==============================================================
ecr_frontend_mutability  = "MUTABLE"
ecr_backend_mutability   = "MUTABLE"
ecr_untagged_expiry_days = 7
ecr_tagged_max_count     = 30
ecr_tagged_prefixes      = ["latest", "dev", "test"]

# ==============================================================
# EKS Configuration
# ==============================================================

kubernetes_version         = "1.30"
cluster_log_retention_days = 30

node_groups = {
  test_nodes = {
    instance_types = ["t3.medium"]
    capacity_type  = "ON_DEMAND"
    desired_size   = 0
    min_size       = 0
    max_size       = 3

    labels = {
      environment = "test"
    }
  }
}

# ==============================================================
# addons
# ==============================================================
eks_addons = {

  aws-ebs-csi-driver = {
    version = "v1.63.0-eksbuild.1"

    service_account_role_name = "test-test-eks-cluster-new-ebs-csi-controller-role"
  }

  vpc-cni = {
    version = "v1.19.2-eksbuild.1"
  }

  coredns = {
    version = "v1.11.4-eksbuild.24"
  }

  kube-proxy = {}

}
