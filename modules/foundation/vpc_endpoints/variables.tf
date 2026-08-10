variable "environment" {
  type        = string
  description = "Deployment environment name"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where endpoints will be created"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block of the VPC"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for Interface VPC Endpoints"
}

variable "private_route_table_ids" {
  type        = list(string)
  description = "Private route table IDs for Gateway VPC Endpoints"
}

variable "enable_s3_endpoint" {
  type        = bool
  description = "Enable S3 Gateway VPC Endpoint"
  default     = true
}

variable "enable_dynamodb_endpoint" {
  type        = bool
  description = "Enable DynamoDB Gateway VPC Endpoint"
  default     = true
}

variable "enable_ecr_endpoints" {
  type        = bool
  description = "Enable ECR API and ECR Docker Interface Endpoints"
  default     = true
}

variable "enable_secretsmanager_endpoint" {
  type        = bool
  description = "Enable Secrets Manager Interface Endpoint"
  default     = true
}

variable "enable_ssm_endpoint" {
  type        = bool
  description = "Enable Systems Manager Interface Endpoint"
  default     = true
}

variable "name_prefix" {
  type        = string
  description = "Prefix used for endpoint resource names"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags for VPC endpoint resources"
  default     = {}
}
