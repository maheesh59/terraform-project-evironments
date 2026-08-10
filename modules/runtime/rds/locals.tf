locals {
  name_prefix = "${var.project_name}-${var.environment}"

  default_tags = merge(
    {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    },
    var.extra_tags
  )
}
