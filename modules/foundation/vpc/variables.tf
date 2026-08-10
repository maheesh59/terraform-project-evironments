variable "environment" {
  type        = string
  description = "Deployment environment name (e.g., test, prod)"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of Public Subnet CIDRs"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of Private Subnet CIDRs"
}

variable "public_subnet_azs" {
  type        = list(string)
  description = "List of Availability Zones for Public Subnets"
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "private_subnet_azs" {
  type        = list(string)
  description = "List of Availability Zones for Private Subnets"
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "aws_region" {
  type        = string
  description = "AWS region for endpoint service lookup"
  default     = "ap-south-1"
}

variable "subnet_tags" {
  type        = map(string)
  description = "Additional tags to apply to all subnets"
  default     = {}
}
