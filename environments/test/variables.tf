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
# Container Registry (ECR) Variables
# ==============================================================

variable "ecr_frontend_mutability" {
  type        = string
  description = "Image tag mutability setting for frontend repository (MUTABLE or IMMUTABLE)"
  default     = "MUTABLE"
}

variable "ecr_backend_mutability" {
  type        = string
  description = "Image tag mutability setting for backend repository (MUTABLE or IMMUTABLE)"
  default     = "MUTABLE"
}

variable "ecr_untagged_expiry_days" {
  type        = number
  description = "Number of days before untagged images are automatically deleted"
}

variable "ecr_tagged_max_count" {
  type        = number
  description = "Maximum number of tagged images to retain per repository"
}

variable "ecr_tagged_prefixes" {
  type        = list(string)
  description = "List of tag prefixes to evaluate for lifecycle retention policy"
  default     = ["latest", "v", "test", "dev"]
}

# ==============================================================
# EKS Variables
# ==============================================================

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version for the EKS cluster"
}

variable "cluster_log_retention_days" {
  type        = number
  description = "Number of days to retain EKS CloudWatch logs"
}

variable "node_groups" {
  type        = any
  description = "EKS managed node group configurations"
  default     = {}
}

# ==============================================================
# addons
# ==============================================================
variable "eks_addons" {
  type = map(any)
}


