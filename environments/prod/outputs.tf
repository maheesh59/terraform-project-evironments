# ==============================================================
# VPC Outputs
# ==============================================================
output "vpc_id" {
  description = "The ID of the VPC"
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

# ==============================================================
# EKS Outputs
# ==============================================================
output "eks_cluster_name" {
  description = "EKS Cluster Name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS Control Plane Endpoint"
  value       = module.eks.cluster_endpoint
}


