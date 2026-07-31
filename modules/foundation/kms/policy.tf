data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "kms_key_policy" {
  # Root Account Admin Permission (prevents locked keys)
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions   = ["kms:*"]
    resources = ["*"]
  }

  # Optional Key Administrators
  dynamic "statement" {
    for_each = length(var.key_administrators) > 0 ? [1] : []

    content {
      sid    = "Allow Key Administration"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = var.key_administrators
      }

      actions = [
        "kms:Create*",
        "kms:Describe*",
        "kms:Enable*",
        "kms:List*",
        "kms:Put*",
        "kms:Update*",
        "kms:Revoke*",
        "kms:Disable*",
        "kms:Get*",
        "kms:Delete*",
        "kms:TagResource",
        "kms:UntagResource",
        "kms:ScheduleKeyDeletion",
        "kms:CancelKeyDeletion"
      ]

      resources = ["*"]
    }
  }

  # Optional Key Users
  dynamic "statement" {
    for_each = length(var.key_users) > 0 ? [1] : []

    content {
      sid    = "Allow Key Usage"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = var.key_users
      }

      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ]

      resources = ["*"]
    }
  }
}
