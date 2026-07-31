locals {
  name_prefix = var.alias_name != null && var.alias_name != "" ? replace(var.alias_name, "alias/", "") : "${var.environment}-kms"

  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )
}
