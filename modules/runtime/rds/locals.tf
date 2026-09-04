locals {
  name_prefix = var.rds_name_prefix != null ? var.rds_name_prefix : "${var.project_name}-${var.environment}"

  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    }
  )
}
