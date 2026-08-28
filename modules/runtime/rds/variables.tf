############################################################
# GENERAL
############################################################

variable "project_name" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "tags" {
  type        = map(string)
  description = "Additional resource tags"
  default     = {}
}

############################################################
# NETWORK
############################################################

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for RDS"

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "At least two subnet IDs must be provided."
  }
}

############################################################
# SECURITY GROUP
############################################################

variable "allowed_security_group_ids" {
  type        = list(string)
  description = "Security groups allowed to access RDS"
  default     = []
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks allowed to access RDS"
  default     = []
}

variable "security_group_description" {
  type        = string
  description = "RDS security group description"
  default     = "Security group for RDS"
}

variable "security_group_ingress_description" {
  type        = string
  description = "Description for security group based ingress rules"
  default     = "Allow database access from application security group"
}

variable "cidr_ingress_description" {
  type        = string
  description = "Description for CIDR based ingress rules"
  default     = "Allow database access from authorized CIDR"
}

variable "ingress_protocol" {
  type        = string
  description = "Ingress protocol"
  default     = "tcp"
}

variable "egress_cidr_block" {
  type        = string
  description = "CIDR allowed for outbound traffic"
  default     = "0.0.0.0/0"
}

variable "egress_protocol" {
  type        = string
  description = "Egress protocol"
  default     = "-1"
}

variable "egress_description" {
  type        = string
  description = "Egress rule description"
  default     = "Allow outbound traffic"
}

############################################################
# DATABASE ENGINE
############################################################

variable "engine" {
  type        = string
  description = "RDS database engine"
}

variable "engine_version" {
  type        = string
  description = "RDS engine version"
}

variable "family" {
  type        = string
  description = "RDS parameter group family"
}

variable "instance_class" {
  type        = string
  description = "RDS instance class"
}

variable "db_name" {
  type        = string
  description = "Initial database name"
}

variable "username" {
  type        = string
  description = "Master username"
}

variable "port" {
  type        = number
  description = "Database port"
}

############################################################
# STORAGE
############################################################

variable "allocated_storage" {
  type        = number
  description = "Initial storage size in GB"
}

variable "max_allocated_storage" {
  type        = number
  description = "Maximum storage size in GB"
}

variable "storage_type" {
  type        = string
  description = "RDS storage type"
}

variable "storage_encrypted" {
  type        = bool
  description = "Enable RDS storage encryption"
  default     = true
}

############################################################
# NETWORK BEHAVIOR
############################################################

variable "multi_az" {
  type        = bool
  description = "Enable Multi-AZ"
}

variable "publicly_accessible" {
  type        = bool
  description = "Make RDS publicly accessible"
}

############################################################
# BACKUP
############################################################

variable "backup_retention_period" {
  type        = number
  description = "Backup retention period in days"
}

variable "preferred_backup_window" {
  type        = string
  description = "Preferred backup window"
}

variable "preferred_maintenance_window" {
  type        = string
  description = "Preferred maintenance window"
}

variable "copy_tags_to_snapshot" {
  type        = bool
  description = "Copy tags to snapshots"
  default     = true
}

############################################################
# DELETION
############################################################

variable "deletion_protection" {
  type        = bool
  description = "Enable deletion protection"
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Skip final snapshot when destroying RDS"
}

############################################################
# PARAMETER GROUP
############################################################

variable "parameters" {
  type = list(object({
    name         = string
    value        = string
    apply_method = optional(string, "immediate")
  }))

  description = "Custom RDS parameters"

  default = []
}

############################################################
# KMS
############################################################

variable "kms_key_arn" {
  type        = string
  description = "Existing KMS key ARN for RDS. Null creates a new key."
  default     = null
}

variable "secrets_manager_kms_key_arn" {
  type        = string
  description = "Existing KMS key ARN for Secrets Manager. Null uses RDS KMS key."
  default     = null
}

variable "kms_deletion_window_in_days" {
  type = number
}

variable "kms_enable_key_rotation" {
  type = bool
}

############################################################
# PASSWORD
############################################################

variable "password" {
  type        = string
  description = "RDS database password"
  sensitive   = true
}

############################################################
# SECRETS MANAGER
############################################################

variable "secret_recovery_window_in_days" {
  type = number
}

############################################################
# MONITORING
############################################################

variable "monitoring_interval" {
  type        = number
  description = "Enhanced Monitoring interval in seconds"
}

variable "enhanced_monitoring_policy_name" {
  type        = string
  description = "AWS managed policy name for RDS Enhanced Monitoring"
  default     = "AmazonRDSEnhancedMonitoringRole"
}

variable "rds_monitoring_service_principal" {
  type        = string
  description = "AWS service principal used by RDS Enhanced Monitoring"
  default     = "monitoring.rds.amazonaws.com"
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  description = "RDS log types exported to CloudWatch"
}

############################################################
# MAINTENANCE
############################################################

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "Enable automatic minor engine version upgrades"
  default     = true
}

############################################################
# SUBNET GROUP
############################################################

variable "subnet_group_description" {
  type        = string
  description = "RDS subnet group description"
  default     = "RDS database subnet group"
}


