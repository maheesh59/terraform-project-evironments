# Helper module concept for Service Account roles
data "aws_iam_policy_document" "aws_lb_controller_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "aws_lb_controller" {
  name               = "${local.name_prefix}-lb-controller-irsa"
  assume_role_policy = data.aws_iam_policy_document.aws_lb_controller_assume.json
  tags               = local.common_tags
}
