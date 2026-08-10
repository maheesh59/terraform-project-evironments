locals {
  name_prefix = "${var.environment}-${var.cluster_name}"

  common_tags = merge(
    {
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.extra_tags
  )
}
