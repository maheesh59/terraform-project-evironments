# ==============================================================
# Global & Project Variables
# ==============================================================

variable "aws_region" {
  type        = string
  description = "AWS Deployment Region"
}

variable "environment" {
  type        = string
  description = "Environment identifier (prod)"
}

variable "project_name" {
  type        = string
  description = "Project name for tags"
  default     = "foundation"
}

# ==============================================================
# Network (VPC) Variables
# ==============================================================

variable "vpc_cidr" {
  type        = string
  description = "CIDR range for VPC"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public subnet CIDRs"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnet CIDRs"
}

variable "public_subnet_azs" {
  type        = list(string)
  description = "AZs for public subnets"
}

variable "private_subnet_azs" {
  type        = list(string)
  description = "AZs for private subnets"
}

variable "subnet_tags" {
  type        = map(string)
  description = "Additional tags for prod subnets"
  default     = {}
}

# ==============================================================
# EKS & Karpenter Variables
# ==============================================================

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version for the EKS cluster"
}

variable "cluster_log_retention_days" {
  type        = number
  description = "Number of days to retain EKS CloudWatch logs"
}

variable "node_groups" {
  type        = any
  description = "EKS managed node group configurations"
  default     = {}
}

# ==============================================================
# Karpenter Variables
# ==============================================================

variable "karpenter_version" {
  type        = string
  description = "Karpenter Helm chart version"
}

variable "sqs_message_retention_seconds" {
  type        = number
  description = "SQS retention period for Karpenter Spot interruption messages"
}

# ============================================================
# RDS
# ============================================================

variable "rds" {
  description = "RDS configuration"

  type = object({
    # DATABASE

    engine         = string
    engine_version = string

    instance_class = string

    db_name  = string
    username = string
    port     = number

    # STORAGE

    allocated_storage     = number
    max_allocated_storage = number
    storage_type          = string
    storage_encrypted     = bool

    # NETWORK

    multi_az            = bool
    publicly_accessible = bool

    # SECURITY GROUP

    allowed_cidr_blocks = list(string)

    security_group_description         = string
    security_group_ingress_description = string
    cidr_ingress_description           = string

    ingress_protocol = string

    egress_cidr        = string
    egress_protocol    = string
    egress_description = string

    # PASSWORD

    password_length             = number
    password_special            = bool
    password_special_characters = string

    # BACKUP

    backup_retention_period = number

    backup_window      = string
    maintenance_window = string

    copy_tags_to_snapshot = bool

    # DELETION

    deletion_protection = bool
    skip_final_snapshot = bool

    # MONITORING

    monitoring_interval = number

    enabled_cloudwatch_logs_exports = list(string)

    # PARAMETER GROUP

    parameter_group_family = string

    parameters = list(object({
      name         = string
      value        = string
      apply_method = optional(string, "immediate")
    }))

    # KMS

    kms_key_arn                 = optional(string, null)
    secrets_manager_kms_key_arn = optional(string, null)
    kms_deletion_window_in_days = number
    kms_enable_key_rotation     = bool

    # SECRETS MANAGER

    secret_recovery_window_in_days = number
  })
}

# ============================================================
# Common Tags
# ============================================================

variable "tags" {
  description = "Common tags for resources"
  type        = map(string)
  default     = {}
}
