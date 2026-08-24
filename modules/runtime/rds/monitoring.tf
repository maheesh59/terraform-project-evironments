data "aws_iam_policy" "rds_enhanced_monitoring" {
  count = var.monitoring_interval > 0 ? 1 : 0

  name = var.enhanced_monitoring_policy_name
}

resource "aws_iam_role" "enhanced_monitoring" {
  count = var.monitoring_interval > 0 ? 1 : 0

  name_prefix = "${local.name_prefix}-rds-monitoring-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = var.rds_monitoring_service_principal
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  count = var.monitoring_interval > 0 ? 1 : 0

  role = aws_iam_role.enhanced_monitoring[0].name

  policy_arn = data.aws_iam_policy.rds_enhanced_monitoring[0].arn
}
