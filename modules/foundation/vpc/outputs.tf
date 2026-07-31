# ==============================================================================
# VPC Outputs
# ==============================================================================

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

# ==============================================================================
# Subnet Outputs
# ==============================================================================

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = [for subnet in aws_subnet.private : subnet.id]
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public_rt.id
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = [for rt in aws_route_table.private_rt : rt.id]
}

# ==============================================================================
# Endpoint Outputs
# ==============================================================================

output "s3_vpc_endpoint_id" {
  description = "The ID of the S3 VPC Endpoint"
  value       = try(aws_vpc_endpoint.s3[0].id, null)
}
