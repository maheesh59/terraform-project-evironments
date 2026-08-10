output "karpenter_iam_role_arn" {
  description = "ARN of the IAM role for Karpenter controller"
  value       = aws_iam_role.controller.arn
}

output "node_iam_role_arn" {
  description = "ARN of the IAM role used by Karpenter-provisioned EC2 nodes"
  value       = aws_iam_role.node.arn
}
