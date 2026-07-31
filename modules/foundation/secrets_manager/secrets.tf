resource "aws_secretsmanager_secret" "this" {
  for_each = var.secrets

  name                    = each.value.name
  description             = each.value.description
  kms_key_id              = each.value.kms_key_id
  recovery_window_in_days = each.value.recovery_window_in_days

  tags = merge(
    local.common_tags,
    {
      Name    = each.value.name
      Purpose = each.key
    },
    each.value.tags
  )
}

resource "aws_secretsmanager_secret_version" "this" {
  for_each = {
    for k, v in var.secrets : k => v
    if v.secret_string != null || length(v.secret_key_values) > 0
  }

  secret_id     = aws_secretsmanager_secret.this[each.key].id
  secret_string = each.value.secret_string != null ? each.value.secret_string : jsonencode(each.value.secret_key_values)
}

resource "aws_secretsmanager_secret_rotation" "this" {
  for_each = {
    for k, v in var.secrets : k => v
    if v.enable_rotation && v.rotation_lambda_arn != null
  }

  secret_id           = aws_secretsmanager_secret.this[each.key].id
  rotation_lambda_arn = each.value.rotation_lambda_arn

  rotation_rules {
    automatically_after_days = each.value.rotation_automatically_after_days
  }
}
