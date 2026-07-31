resource "aws_kms_alias" "this" {
  count         = var.alias_name != null && var.alias_name != "" ? 1 : 0
  name          = startswith(var.alias_name, "alias/") ? var.alias_name : "alias/${var.alias_name}"
  target_key_id = aws_kms_key.this.key_id
}
