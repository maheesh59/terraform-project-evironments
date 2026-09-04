variable "name" {
  description = "SonarQube EC2 instance name"
  type        = string
}

variable "aws_region" {
  description = "AWS region where SonarQube is deployed"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where SonarQube is deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs where SonarQube can be deployed"
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_ids) >= 1
    error_message = "At least one private subnet ID must be provided."
  }
}

variable "alb_security_group_id" {
  description = "Security group ID of the ALB allowed to access SonarQube"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for SonarQube"
  type        = string
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number

  validation {
    condition     = var.root_volume_size >= 30
    error_message = "root_volume_size must be at least 30 GB."
  }
}

variable "ami_id" {
  description = "Optional custom AMI ID. Null uses the latest Amazon Linux 2023 AMI."
  type        = string
  default     = null
}

variable "sonarqube_version" {
  description = "SonarQube version to install"
  type        = string
}

variable "java_version" {
  description = "Java major version required by SonarQube"
  type        = number

  validation {
    condition     = contains([17, 21], var.java_version)
    error_message = "java_version must be either 17 or 21."
  }
}

variable "database_name" {
  description = "SonarQube PostgreSQL database name"
  type        = string
}

variable "database_username" {
  description = "SonarQube PostgreSQL username"
  type        = string
}

variable "database_port" {
  description = "PostgreSQL database port"
  type        = number

  validation {
    condition     = var.database_port > 0 && var.database_port <= 65535
    error_message = "database_port must be between 1 and 65535."
  }
}

variable "database_password" {
  description = "SonarQube PostgreSQL database password"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.database_password) >= 8
    error_message = "database_password must be at least 8 characters long."
  }
}
