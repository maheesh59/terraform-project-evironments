# ==============================================================================
# AWS Load Balancer Controller
# IAM Policy
# Location: modules/runtime/load-balancer-controller/policy.tf
# ==============================================================================

data "aws_iam_policy_document" "lb_controller" {
  count = var.enable_aws_load_balancer_controller ? 1 : 0

  # --------------------------------------------------------------------------
  # EC2 - Create Security Group
  # --------------------------------------------------------------------------

  statement {
    sid    = "CreateSecurityGroup"
    effect = "Allow"

    actions = [
      "ec2:CreateSecurityGroup"
    ]

    resources = [
      "*"
    ]
  }

  # --------------------------------------------------------------------------
  # EC2 - Create Tags
  # --------------------------------------------------------------------------

  statement {
    sid    = "CreateTags"
    effect = "Allow"

    actions = [
      "ec2:CreateTags"
    ]

    resources = [
      "arn:aws:ec2:*:*:security-group/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"

      values = [
        "CreateSecurityGroup"
      ]
    }

    condition {
      test     = "Null"
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"

      values = [
        "false"
      ]
    }
  }

  # --------------------------------------------------------------------------
  # EC2 - Tags for Existing Security Groups
  # --------------------------------------------------------------------------

  statement {
    sid    = "CreateTagsExisting"
    effect = "Allow"

    actions = [
      "ec2:CreateTags",
      "ec2:DeleteTags"
    ]

    resources = [
      "arn:aws:ec2:*:*:security-group/*"
    ]

    condition {
      test     = "Null"
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"

      values = [
        "true"
      ]
    }

    condition {
      test     = "Null"
      variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"

      values = [
        "false"
      ]
    }
  }

  # --------------------------------------------------------------------------
  # EC2 - Security Group Rules
  # --------------------------------------------------------------------------

  statement {
    sid    = "ManageSecurityGroupRules"
    effect = "Allow"

    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupIngress"
    ]

    resources = [
      "*"
    ]
  }

  # --------------------------------------------------------------------------
  # EC2 - Delete Security Groups
  # --------------------------------------------------------------------------

  statement {
    sid    = "DeleteSecurityGroup"
    effect = "Allow"

    actions = [
      "ec2:DeleteSecurityGroup"
    ]

    resources = [
      "*"
    ]
  }

  # --------------------------------------------------------------------------
  # EC2 - Describe
  # --------------------------------------------------------------------------

  statement {
    sid    = "EC2DescribePermissions"
    effect = "Allow"

    actions = [
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInstances",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVpcs"
    ]

    resources = [
      "*"
    ]
  }

  # --------------------------------------------------------------------------
  # Elastic Load Balancing - Read
  # --------------------------------------------------------------------------

  statement {
    sid    = "ELBReadPermissions"
    effect = "Allow"

    actions = [
      "elasticloadbalancing:DescribeListenerAttributes",
      "elasticloadbalancing:DescribeListenerCertificates",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeSSLPolicies",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth"
    ]

    resources = [
      "*"
    ]
  }

  # --------------------------------------------------------------------------
  # Elastic Load Balancing - Create
  # --------------------------------------------------------------------------

  statement {
    sid    = "ELBCreatePermissions"
    effect = "Allow"

    actions = [
      "elasticloadbalancing:AddListenerCertificates",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateRule",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteRule",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:ModifyRule",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:RemoveListenerCertificates",
      "elasticloadbalancing:RemoveTags",
      "elasticloadbalancing:SetIpAddressType",
      "elasticloadbalancing:SetSecurityGroups",
      "elasticloadbalancing:SetSubnets"
    ]

    resources = [
      "*"
    ]
  }

  # --------------------------------------------------------------------------
  # Elastic Load Balancing - Web ACL
  # --------------------------------------------------------------------------

  statement {
    sid    = "ELBWAFPermissions"
    effect = "Allow"

    actions = [
      "elasticloadbalancing:SetWebAcl"
    ]

    resources = [
      "*"
    ]
  }

  # --------------------------------------------------------------------------
  # Cognito
  # --------------------------------------------------------------------------

  statement {
    sid    = "CognitoPermissions"
    effect = "Allow"

    actions = [
      "cognito-idp:DescribeUserPoolClient"
    ]

    resources = [
      "*"
    ]
  }

  # --------------------------------------------------------------------------
  # ACM
  # --------------------------------------------------------------------------

  statement {
    sid    = "ACMPermissions"
    effect = "Allow"

    actions = [
      "acm:ListCertificates",
      "acm:DescribeCertificate"
    ]

    resources = [
      "*"
    ]
  }

  # --------------------------------------------------------------------------
  # IAM - Service Linked Role
  # --------------------------------------------------------------------------

  statement {
    sid    = "IAMCreateServiceLinkedRole"
    effect = "Allow"

    actions = [
      "iam:CreateServiceLinkedRole"
    ]

    resources = [
      "*"
    ]

    condition {
      test     = "StringEquals"
      variable = "iam:AWSServiceName"

      values = [
        "elasticloadbalancing.amazonaws.com"
      ]
    }
  }

  # --------------------------------------------------------------------------
  # Shield
  # --------------------------------------------------------------------------

  dynamic "statement" {
    for_each = var.enable_shield ? [1] : []

    content {
      sid    = "ShieldPermissions"
      effect = "Allow"

      actions = [
        "shield:CreateProtection",
        "shield:DeleteProtection",
        "shield:DescribeProtection",
        "shield:GetSubscriptionState",
        "shield:ListProtections"
      ]

      resources = [
        "*"
      ]
    }
  }

  # --------------------------------------------------------------------------
  # WAF Classic
  # --------------------------------------------------------------------------

  dynamic "statement" {
    for_each = var.enable_waf ? [1] : []

    content {
      sid    = "WAFPermissions"
      effect = "Allow"

      actions = [
        "waf-regional:GetWebACL",
        "waf-regional:GetWebACLForResource",
        "waf-regional:AssociateWebACL",
        "waf-regional:DisassociateWebACL",
        "waf-regional:ListResourcesForWebACL",
        "waf-regional:ListWebACLs"
      ]

      resources = [
        "*"
      ]
    }
  }

  # --------------------------------------------------------------------------
  # WAFv2
  # --------------------------------------------------------------------------

  dynamic "statement" {
    for_each = var.enable_wafv2 ? [1] : []

    content {
      sid    = "WAFv2Permissions"
      effect = "Allow"

      actions = [
        "wafv2:GetWebACL",
        "wafv2:GetWebACLForResource",
        "wafv2:AssociateWebACL",
        "wafv2:DisassociateWebACL",
        "wafv2:ListResourcesForWebACL",
        "wafv2:ListWebACLs"
      ]

      resources = [
        "*"
      ]
    }
  }

  # --------------------------------------------------------------------------
  # Route53
  # --------------------------------------------------------------------------

  statement {
    sid    = "Route53Permissions"
    effect = "Allow"

    actions = [
      "route53:GetChange"
    ]

    resources = [
      "arn:aws:route53:::change/*"
    ]
  }

  # --------------------------------------------------------------------------
  # Resource Groups Tagging API
  # --------------------------------------------------------------------------

  statement {
    sid    = "TagPermissions"
    effect = "Allow"

    actions = [
      "tag:GetResources"
    ]

    resources = [
      "*"
    ]
  }
}
