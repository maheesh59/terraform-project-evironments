# ==============================================================================
# VPC Endpoint Outputs
# ==============================================================================

output "vpc_endpoint_security_group_id" {
  description = "Security group ID used by Interface VPC Endpoints"
  value       = aws_security_group.vpc_endpoints.id
}

output "s3_vpc_endpoint_id" {
  description = "S3 Gateway VPC Endpoint ID"
  value       = try(aws_vpc_endpoint.s3[0].id, null)
}

output "dynamodb_vpc_endpoint_id" {
  description = "DynamoDB Gateway VPC Endpoint ID"
  value       = try(aws_vpc_endpoint.dynamodb[0].id, null)
}

output "ecr_api_vpc_endpoint_id" {
  description = "ECR API Interface VPC Endpoint ID"
  value       = try(aws_vpc_endpoint.ecr_api[0].id, null)
}

output "ecr_dkr_vpc_endpoint_id" {
  description = "ECR Docker Interface VPC Endpoint ID"
  value       = try(aws_vpc_endpoint.ecr_dkr[0].id, null)
}

output "secretsmanager_vpc_endpoint_id" {
  description = "Secrets Manager Interface VPC Endpoint ID"
  value       = try(aws_vpc_endpoint.secretsmanager[0].id, null)
}

output "ssm_vpc_endpoint_id" {
  description = "Systems Manager Interface VPC Endpoint ID"
  value       = try(aws_vpc_endpoint.ssm[0].id, null)
}
