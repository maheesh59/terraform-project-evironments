# ==============================================================
# Global & Project Variables
# ==============================================================

variable "aws_region" {
  type        = string
  description = "AWS Deployment Region"
}

variable "environment" {
  type        = string
  description = "Environment identifier (prod)"
}

variable "project_name" {
  type        = string
  description = "Project name for tags"
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
  description = "AZs for public subnets"
}

variable "private_subnet_azs" {
  type        = list(string)
  description = "AZs for private subnets"
}

variable "subnet_tags" {
  type        = map(string)
  description = "Additional tags for prod subnets"
  default     = {}
}

# ==============================================================
# EKS & Karpenter Variables
# ==============================================================

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes Version for EKS"
  default     = "1.30"
}

variable "node_groups" {
  type        = any
  description = "EKS managed node group configurations"
  default     = {}
}
