# ==============================================================
# Global & Project Variables
# ==============================================================

variable "aws_region" {
  type        = string
  description = "AWS Deployment Region"
}

variable "environment" {
  type        = string
  description = "Environment identifier (test)"
}

variable "project_name" {
  type        = string
  description = "Project name used for resource naming and tags"
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
  description = "Availability Zones for Public Subnets"
}

variable "private_subnet_azs" {
  type        = list(string)
  description = "Availability Zones for Private Subnets"
}

# ==============================================================
# Container Registry (ECR) Variables
# ==============================================================

variable "ecr_frontend_mutability" {
  type        = string
  description = "Image tag mutability setting for frontend repository (MUTABLE or IMMUTABLE)"
  default     = "MUTABLE"
}

variable "ecr_backend_mutability" {
  type        = string
  description = "Image tag mutability setting for backend repository (MUTABLE or IMMUTABLE)"
  default     = "MUTABLE"
}

variable "ecr_untagged_expiry_days" {
  type        = number
  description = "Number of days before untagged images are automatically deleted"
}

variable "ecr_tagged_max_count" {
  type        = number
  description = "Maximum number of tagged images to retain per repository"
}

variable "ecr_tagged_prefixes" {
  type        = list(string)
  description = "List of tag prefixes to evaluate for lifecycle retention policy"
  default     = ["latest", "v", "test", "dev"]
}

# ==============================================================
# EKS Variables
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
# addons
# ==============================================================
variable "eks_addons" {
  type = map(any)
}


# ============================================================
# RDS
# ============================================================

variable "rds" {
  description = "RDS configuration"

  type = object({
    # --------------------------------------------------------
    # DATABASE
    # --------------------------------------------------------
    engine         = string
    engine_version = string
    instance_class = string
    db_name        = string
    username       = string
    password       = string
    port           = number

    # --------------------------------------------------------
    # STORAGE
    # --------------------------------------------------------
    allocated_storage     = number
    max_allocated_storage = number
    storage_type          = string
    storage_encrypted     = bool

    # --------------------------------------------------------
    # NETWORK
    # --------------------------------------------------------
    multi_az            = bool
    publicly_accessible = bool

    # --------------------------------------------------------
    # SECURITY GROUP
    # --------------------------------------------------------
    allowed_cidr_blocks                = list(string)
    security_group_description         = string
    security_group_ingress_description = string
    cidr_ingress_description           = string
    ingress_protocol                   = string
    egress_cidr                        = string
    egress_protocol                    = string
    egress_description                 = string

    # --------------------------------------------------------
    # BACKUP
    # --------------------------------------------------------
    backup_retention_period = number
    backup_window           = string
    maintenance_window      = string
    copy_tags_to_snapshot   = bool

    # --------------------------------------------------------
    # DELETION
    # --------------------------------------------------------
    deletion_protection = bool
    skip_final_snapshot = bool

    # --------------------------------------------------------
    # MONITORING
    # --------------------------------------------------------
    monitoring_interval             = number
    enabled_cloudwatch_logs_exports = list(string)

    # --------------------------------------------------------
    # PARAMETER GROUP
    # --------------------------------------------------------
    parameter_group_family = string

    parameters = list(object({
      name         = string
      value        = string
      apply_method = optional(string, "immediate")
    }))

    # --------------------------------------------------------
    # KMS
    # --------------------------------------------------------
    kms_key_arn                 = optional(string, null)
    secrets_manager_kms_key_arn = optional(string, null)
    kms_deletion_window_in_days = number
    kms_enable_key_rotation     = bool

    # --------------------------------------------------------
    # SECRETS MANAGER
    # --------------------------------------------------------
    secret_recovery_window_in_days = number
  })
}

# ============================================================
# COMMON TAGS
# ============================================================

variable "tags" {
  description = "Common tags for resources"

  type = map(string)

  default = {}
}

# ==============================================================================
# AWS Load Balancer Controller - Test Variables
# ==============================================================================

variable "enable_aws_load_balancer_controller" {
  description = "Enable AWS Load Balancer Controller"
  type        = bool
  default     = true
}

variable "lb_controller_replica_count" {
  description = "Number of AWS Load Balancer Controller replicas"
  type        = number
  default     = 1
}

variable "lb_controller_chart_version" {
  description = "AWS Load Balancer Controller Helm chart version"
  type        = string
  default     = "1.7.1"
}

variable "enable_waf" {
  description = "Enable AWS WAF"
  type        = bool
  default     = false
}

variable "enable_wafv2" {
  description = "Enable AWS WAFv2"
  type        = bool
  default     = false
}

variable "enable_shield" {
  description = "Enable AWS Shield Advanced"
  type        = bool
  default     = false
}
