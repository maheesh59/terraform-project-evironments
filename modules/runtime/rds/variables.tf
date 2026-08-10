# ==============================================================
# General & Naming
# ==============================================================
variable "environment" {
  type        = string
  description = "Target environment (e.g., prod, staging)"
}

variable "project_name" {
  type        = string
  description = "Project name for tags and naming conventions"
}

variable "extra_tags" {
  type        = map(string)
  description = "Additional tags to apply to all resources"
  default     = {}
}

# ==============================================================
# Networking
# ==============================================================
variable "vpc_id" {
  type        = string
  description = "VPC ID where RDS and security groups will be deployed"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for the RDS DB Subnet Group"
}

variable "allowed_security_group_ids" {
  type        = list(string)
  description = "List of Security Group IDs allowed to connect to RDS"
  default     = []
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks allowed to connect to RDS"
  default     = []
}

# ==============================================================
# Database Configuration
# ==============================================================
variable "engine" {
  type        = string
  description = "Database engine (e.g., postgres, mysql)"
  default     = "postgres"
}

variable "engine_version" {
  type        = string
  description = "Database engine version"
  default     = "15.4"
}

variable "family" {
  type        = string
  description = "DB parameter group family (e.g., postgres15, mysql8.0)"
  default     = "postgres15"
}

variable "instance_class" {
  type        = string
  description = "RDS instance class for production (e.g., db.m6i.large)"
  default     = "db.m6i.large"
}

variable "allocated_storage" {
  type        = number
  description = "Initial allocated storage in GB"
  default     = 50
}

variable "max_allocated_storage" {
  type        = number
  description = "Upper limit for storage autoscaling in GB (0 to disable)"
  default     = 500
}

variable "storage_type" {
  type        = string
  description = "Storage type (gp3 recommended for production)"
  default     = "gp3"
}

variable "port" {
  type        = number
  description = "Database connection port"
  default     = 5432
}

variable "db_name" {
  type        = string
  description = "Initial database name"
}

variable "username" {
  type        = string
  description = "Master username for the database"
  default     = "dbadmin"
}

variable "multi_az" {
  type        = bool
  description = "Enable Multi-AZ deployment for high availability"
  default     = true
}

variable "publicly_accessible" {
  type        = bool
  description = "Controls if instance is publicly accessible"
  default     = false
}

variable "deletion_protection" {
  type        = bool
  description = "Prevent accidental database deletion"
  default     = true
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Skip final snapshot before deletion"
  default     = false
}

variable "parameters" {
  type = list(object({
    name         = string
    value        = string
    apply_method = optional(string, "immediate")
  }))
  description = "Custom parameters to pass to DB parameter group"
  default     = []
}

# ==============================================================
# Encryption & Security
# ==============================================================
variable "kms_key_arn" {
  type        = string
  description = "KMS Key ARN for storage encryption. If null, a new key is created."
  default     = null
}

# ==============================================================
# Backups & Maintenance
# ==============================================================
variable "backup_retention_period" {
  type        = number
  description = "Days to retain automated backups"
  default     = 30
}

variable "preferred_backup_window" {
  type        = string
  description = "Daily time range during which automated backups are created (UTC)"
  default     = "02:00-03:00"
}

variable "preferred_maintenance_window" {
  type        = string
  description = "Weekly time range during which system maintenance can occur (UTC)"
  default     = "Sun:04:00-Sun:05:00"
}

# ==============================================================
# Monitoring & Logging
# ==============================================================
variable "monitoring_interval" {
  type        = number
  description = "Enhanced Monitoring interval in seconds (0, 1, 5, 10, 15, 30, 60)"
  default     = 60
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  description = "List of log types to export to CloudWatch"
  default     = ["postgresql", "upgrade"]
}
