# ==============================================================
# Global & Project Variables
# ==============================================================

variable "aws_region" {
  type        = string
  description = "AWS Deployment Region"
}

variable "environment" {
  type        = string
  description = "Environment identifier (test)"
}

variable "project_name" {
  type        = string
  description = "Project name used for resource naming and tags"
  default     = "foundation"
}

variable "owner" {
  type        = string
  description = "Owner or team managing the infrastructure"
  default     = "devops"
}

# ==============================================================
# Network (VPC) Variables
# ==============================================================

variable "vpc_cidr" {
  type        = string
  description = "CIDR range for VPC"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public subnet CIDRs"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnet CIDRs"
}

variable "public_subnet_azs" {
  type        = list(string)
  description = "Availability Zones for Public Subnets"
}

variable "private_subnet_azs" {
  type        = list(string)
  description = "Availability Zones for Private Subnets"
}

# ==============================================================
# Secrets Variables
# ==============================================================

variable "db_password" {
  type        = string
  description = "Database password stored in Secrets Manager"
  sensitive   = true
}
