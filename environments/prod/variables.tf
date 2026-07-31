variable "aws_region" {
  type        = string
  description = "AWS Deployment Region"
}

variable "environment" {
  type        = string
  description = "Environment identifier (prod)"
}

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

variable "db_password" {
  type        = string
  description = "Master password stored in Secrets Manager"
  sensitive   = true
}
