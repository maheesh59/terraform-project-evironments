output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC Provider for IRSA"
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "oidc_provider_url" {
  description = "URL of the OIDC Provider for IRSA"
  value       = aws_iam_openid_connect_provider.eks.url
}

output "node_security_group_id" {
  description = "Security Group ID attached to worker nodes"
  value       = aws_security_group.nodes.id
}

output "node_iam_role_name" {
  description = "Name of the IAM role for EKS worker nodes"
  value       = aws_iam_role.node.name
}

output "node_iam_role_arn" {
  description = "ARN of the IAM role for EKS worker nodes"
  value       = aws_iam_role.node.arn
}

# Aliases for backward compatibility with existing module references
output "node_role_name" {
  description = "Alias for node_iam_role_name"
  value       = aws_iam_role.node.name
}

output "node_role_arn" {
  description = "Alias for node_iam_role_arn"
  value       = aws_iam_role.node.arn
}

output "cluster_primary_security_group_id" {
  description = "Cluster security group created by the EKS control plane"
  value       = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}
