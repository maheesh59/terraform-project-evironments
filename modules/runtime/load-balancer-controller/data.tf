# ==============================================================================
# AWS Load Balancer Controller
# Data Sources
# Location: modules/runtime/load-balancer-controller/data.tf
# ==============================================================================

# ------------------------------------------------------------------------------
# AWS Account
# ------------------------------------------------------------------------------

data "aws_caller_identity" "current" {}

# ------------------------------------------------------------------------------
# IAM Trust Policy - IRSA
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "lb_controller_assume_role" {
  count = var.enable_aws_load_balancer_controller ? 1 : 0

  statement {
    sid    = "AllowAssumeRoleWithWebIdentity"
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        local.oidc_provider_arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider_id}:aud"

      values = [
        var.oidc_audience
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider_id}:sub"

      values = [
        local.service_account_full_name
      ]
    }
  }
}
