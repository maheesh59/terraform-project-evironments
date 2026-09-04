resource "aws_kms_key" "this" {
  description              = var.description
  deletion_window_in_days  = var.deletion_window_in_days
  enable_key_rotation      = var.enable_key_rotation
  is_enabled               = var.is_enabled
  key_usage                = var.key_usage
  customer_master_key_spec = var.customer_master_key_spec

  policy = data.aws_iam_policy_document.kms_key_policy.json

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-key"
    }
  )
}
