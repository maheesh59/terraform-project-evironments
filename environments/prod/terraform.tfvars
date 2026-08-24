aws_region   = "ap-south-1"
environment  = "prod"
project_name = "foundation"
vpc_cidr     = "10.20.0.0/16" # Name: foundation-prod-vpc

# Public Subnets
public_subnet_cidrs = [
  "10.20.1.0/24", # Subnet Name: prod-public-ap-south-1a
  "10.20.2.0/24"  # Subnet Name: prod-public-ap-south-1b
]

public_subnet_azs = [
  "ap-south-1a",
  "ap-south-1b"
]

# Private Subnets
private_subnet_cidrs = [
  "10.20.11.0/24", # Subnet Name: prod-private-ap-south-1a
  "10.20.12.0/24"  # Subnet Name: prod-private-ap-south-1b
]

private_subnet_azs = [
  "ap-south-1a",
  "ap-south-1b"
]

# ============================================================
# EKS
# ============================================================

subnet_tags = {
  "karpenter.sh/discovery" = "foundation-prod-cluster"
}

kubernetes_version         = "1.31"
cluster_log_retention_days = 90

# EKS bootstrap/system node group
node_groups = {
  system = {
    desired_size = 2
    min_size     = 2
    max_size     = 3

    ami_type       = "AL2023_x86_64_STANDARD"
    capacity_type  = "ON_DEMAND"
    instance_types = ["t3.medium"]

    labels = {
      workload = "system"
    }
  }
}

# ==============================================================
# Karpenter Configuration
# ==============================================================

karpenter_version             = "1.0.0"
sqs_message_retention_seconds = 300

# ============================================================
# RDS
# ============================================================

rds = {
  # DATABASE
  engine         = "postgres"
  engine_version = "16"
  instance_class = "db.t3.small"

  db_name  = "appdb"
  username = "dbowner"
  port     = 5432

  # STORAGE
  allocated_storage     = 50
  max_allocated_storage = 200
  storage_type          = "gp3"
  storage_encrypted     = true

  # NETWORK
  multi_az            = true
  publicly_accessible = false

  # BACKUP
  backup_retention_period = 30
  backup_window           = "03:00-04:00"
  maintenance_window      = "Sun:04:00-Sun:05:00"
  copy_tags_to_snapshot   = true

  # MONITORING
  monitoring_interval = 60

  enabled_cloudwatch_logs_exports = [
    "postgresql",
    "upgrade"
  ]

  # DELETION
  deletion_protection = true
  skip_final_snapshot = false

  # PARAMETER GROUP
  parameter_group_family = "postgres16"
  parameters             = []

  # PASSWORD
  password_length             = 32
  password_special            = true
  password_special_characters = "!#$%&*+-=?@^_"

  # KMS
  kms_deletion_window_in_days = 30
  kms_enable_key_rotation     = true

  # SECRETS MANAGER
  secret_recovery_window_in_days = 7

  # SECURITY GROUP
  allowed_cidr_blocks = []

  security_group_description         = "Production RDS security group"
  security_group_ingress_description = "Allow PostgreSQL access from EKS"
  cidr_ingress_description           = "Allow PostgreSQL access from authorized CIDR"

  ingress_protocol = "tcp"

  egress_cidr        = "0.0.0.0/0"
  egress_protocol    = "-1"
  egress_description = "Allow outbound traffic"
}
