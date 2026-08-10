resource "aws_sqs_queue" "interruption" {
  count                     = var.enable_spot_termination_handling ? 1 : 0
  name                      = "${var.cluster_name}-karpenter"
  message_retention_seconds = var.sqs_message_retention_seconds
  sqs_managed_sse_enabled   = true

  tags = var.extra_tags
}
