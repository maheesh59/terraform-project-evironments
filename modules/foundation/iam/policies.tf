# ==============================================================
# IAM Policy Configuration
# ==============================================================

resource "aws_iam_policy" "policies" {
  for_each = var.policies

  name        = "${local.name_prefix}-${each.key}-policy"
  description = each.value.description
  policy      = each.value.policy_json

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-${each.key}-policy"
  })
}

# ==============================================================
# IAM Role Policy Attachments
# ==============================================================

resource "aws_iam_role_policy_attachment" "attachments" {
  for_each = var.role_policy_attachments

  role       = aws_iam_role.roles[each.value.role_key].name
  policy_arn = aws_iam_policy.policies[each.value.policy_key].arn
}
