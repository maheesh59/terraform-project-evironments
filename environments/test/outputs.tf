# ==============================================================
# VPC Outputs
# ==============================================================
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

# ==============================================================
# ECR Outputs
# ==============================================================
output "ecr_repository_urls" {
  description = "Map of created ECR repository URLs for image push/pull operations"
  value       = module.ecr.repository_urls
}

output "ecr_repository_arns" {
  description = "Map of created ECR repository ARNs for IAM policy bindings"
  value       = module.ecr.repository_arns
}

# EKS Outputs
output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}


