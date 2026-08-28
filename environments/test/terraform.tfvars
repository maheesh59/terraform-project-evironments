# ==============================================================

# Global Configuration

# ==============================================================

aws_region   = "ap-south-1"
environment  = "test"
project_name = "foundation"

# ==============================================================

# VPC Configuration

# ==============================================================

vpc_cidr = "10.10.0.0/16"

# 2 Public Subnets

public_subnet_cidrs = [
  "10.10.1.0/24",
  "10.10.2.0/24"
]

public_subnet_azs = [
  "ap-south-1a",
  "ap-south-1b"
]

# 2 Private Subnets

private_subnet_cidrs = [
  "10.10.11.0/24",
  "10.10.12.0/24"
]

private_subnet_azs = [
  "ap-south-1a",
  "ap-south-1b"
]

# ==============================================================

# Container Registry (ECR)

# ==============================================================

ecr_frontend_mutability  = "MUTABLE"
ecr_backend_mutability   = "MUTABLE"
ecr_untagged_expiry_days = 7
ecr_tagged_max_count     = 30

ecr_tagged_prefixes = [
  "latest",
  "dev",
  "test"
]

# ==============================================================

# EKS Configuration

# ==============================================================

kubernetes_version         = "1.31"
cluster_log_retention_days = 30

node_groups = {
  test_nodes = {
    instance_types = ["m7i-flex.large"]
    capacity_type  = "ON_DEMAND"

    desired_size = 2
    min_size     = 2
    max_size     = 3

    labels = {
      environment = "test"
    }

  }
}

# ==============================================================

# EKS Add-ons

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

# ==============================================================
# RDS Configuration
# ==============================================================
rds = {
  # ------------------------------------------------------------
  # DATABASE
  # ------------------------------------------------------------
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  db_name        = "appdb"
  username       = "dbowner"
  password       = "Dbone@1" # Direct password provided here
  port           = 3306

  # ------------------------------------------------------------
  # STORAGE
  # ------------------------------------------------------------
  allocated_storage     = 20
  max_allocated_storage = 50
  storage_type          = "gp3"
  storage_encrypted     = true

  # ------------------------------------------------------------
  # NETWORK
  # ------------------------------------------------------------
  multi_az            = false
  publicly_accessible = false

  # ------------------------------------------------------------
  # SECURITY GROUP
  # ------------------------------------------------------------
  allowed_cidr_blocks                = []
  security_group_description         = "Test RDS security group"
  security_group_ingress_description = "Allow MySQL access from EKS"
  cidr_ingress_description           = "Allow MySQL access from authorized CIDR"
  ingress_protocol                   = "tcp"
  egress_cidr                        = "0.0.0.0/0"
  egress_protocol                    = "-1"
  egress_description                 = "Allow outbound traffic"

  # ------------------------------------------------------------
  # BACKUP
  # ------------------------------------------------------------
  backup_retention_period = 0
  backup_window           = "03:00-04:00"
  maintenance_window      = "Sun:04:00-Sun:05:00"
  copy_tags_to_snapshot   = true

  # ------------------------------------------------------------
  # DELETION
  # ------------------------------------------------------------
  deletion_protection = false
  skip_final_snapshot = true

  # ------------------------------------------------------------
  # MONITORING
  # ------------------------------------------------------------
  monitoring_interval = 60
  enabled_cloudwatch_logs_exports = [
    "error",
    "general",
    "slowquery"
  ]

  # ------------------------------------------------------------
  # PARAMETER GROUP
  # ------------------------------------------------------------
  parameter_group_family = "mysql8.0"
  parameters             = []

  # ------------------------------------------------------------
  # KMS & SECRETS MANAGER
  # ------------------------------------------------------------
  kms_key_arn                    = null
  secrets_manager_kms_key_arn    = null
  kms_deletion_window_in_days    = 7
  kms_enable_key_rotation        = true
  secret_recovery_window_in_days = 0
}

# ==============================================================
# COMMON TAGS
# ==============================================================
tags = {
  Environment = "test"
  Project     = "foundation"
  ManagedBy   = "Terraform"
}


# ==============================================================================
# AWS Load Balancer Controller
# ==============================================================================

enable_aws_load_balancer_controller = true

lb_controller_replica_count = 1

lb_controller_chart_version = "1.7.1"

# ==============================================================================
# WAF / Shield
# ==============================================================================

enable_waf = false

enable_wafv2 = false

enable_shield = false
