locals {
  # Merge default tags with caller-provided tags
  common_tags = merge(
    {
      ManagedBy = "Terraform"
      Module    = "modules/foundation/s3"
    },
    var.tags
  )
}
