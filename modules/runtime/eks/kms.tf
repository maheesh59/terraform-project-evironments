# KMS Key Policy for EKS, EBS, CloudWatch Logs, and Auto Scaling
data "aws_iam_policy_document" "eks_kms" {
  # 1. Root account permissions
  statement {
    sid    = "EnableIAMUserPermissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  # 2. CloudWatch Logs (Unrestricted Service Access)
  statement {
    sid    = "AllowCloudWatchLogs"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["logs.${data.aws_region.current.name}.amazonaws.com"]
    }
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }

  # 3. Allow EC2 and Auto Scaling service (Required for encrypted EBS Node volumes)
  statement {
    sid    = "AllowEC2AndAutoScalingToUseKey"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:CreateGrant",
      "kms:DescribeKey"
    ]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values = [
        "ec2.${data.aws_region.current.name}.amazonaws.com",
        "autoscaling.${data.aws_region.current.name}.amazonaws.com"
      ]
    }
  }

  # 4. Allow Auto Scaling Service-Linked Role dynamically via StringLike condition
  statement {
    sid    = "AllowAutoScalingServiceRole"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:CreateGrant",
      "kms:DescribeKey"
    ]
    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "aws:PrincipalArn"
      values   = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling*"]
    }
  }
}

# KMS Key resource
resource "aws_kms_key" "eks" {
  description             = "KMS key for EKS ${var.cluster_name} logs and secrets"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.eks_kms.json

  tags = local.common_tags
}

# KMS Alias resource
resource "aws_kms_alias" "eks" {
  name          = "alias/${var.environment}-${var.cluster_name}-eks"
  target_key_id = aws_kms_key.eks.key_id
}
