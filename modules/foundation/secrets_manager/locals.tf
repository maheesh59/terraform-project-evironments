locals {
  common_tags = merge(
    {
      ManagedBy = "Terraform"
      Module    = "modules/foundation/secrets_manager"
    },
    var.tags
  )
}
