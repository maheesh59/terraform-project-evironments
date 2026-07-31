resource "aws_secretsmanager_secret_policy" "this" {
  for_each = {
    for k, v in var.secrets : k => v
    if v.policy_json != null
  }

  secret_arn = aws_secretsmanager_secret.this[each.key].arn
  policy     = each.value.policy_json
}
