# ==============================================================================
# AWS Load Balancer Controller
# IAM Role and Policy Attachment
# Location: modules/runtime/load-balancer-controller/iam.tf
# ==============================================================================

# ------------------------------------------------------------------------------
# IAM Policy
# ------------------------------------------------------------------------------

resource "aws_iam_policy" "lb_controller" {
  count = var.enable_aws_load_balancer_controller ? 1 : 0

  name = local.iam_policy_name

  description = (
    "${var.lb_controller_iam_policy_description} - ${var.cluster_name}"
  )

  policy = data.aws_iam_policy_document.lb_controller[0].json

  tags = local.common_tags
}

# ------------------------------------------------------------------------------
# IAM Role
# ------------------------------------------------------------------------------

resource "aws_iam_role" "lb_controller" {
  count = var.enable_aws_load_balancer_controller ? 1 : 0

  name = local.iam_role_name

  description = (
    "${var.lb_controller_iam_role_description} - ${var.cluster_name}"
  )

  assume_role_policy = (
    data.aws_iam_policy_document.lb_controller_assume_role[0].json
  )

  tags = local.common_tags
}

# ------------------------------------------------------------------------------
# Attach Policy to Role
# ------------------------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "lb_controller" {
  count = var.enable_aws_load_balancer_controller ? 1 : 0

  role = aws_iam_role.lb_controller[0].name

  policy_arn = aws_iam_policy.lb_controller[0].arn
}
