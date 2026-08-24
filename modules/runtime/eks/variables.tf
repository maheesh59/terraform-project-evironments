variable "environment" {
  type        = string
  description = "Environment name (e.g., prod, test)"
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version for the EKS cluster"
}


variable "vpc_id" {
  type        = string
  description = "VPC ID where EKS cluster and nodes will be deployed"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for EKS worker nodes and control plane"
}

variable "cluster_log_retention_days" {
  type        = number
  description = "Number of days to retain CloudWatch logs for the cluster"
}

variable "extra_tags" {
  type        = map(string)
  description = "Additional tags to append to module resources"
  default     = {}
}

variable "kms_key_arn" {
  type        = string
  description = "Optional custom KMS key ARN for encrypting CloudWatch log group. If null or empty, a key will be created."
  default     = null
}

variable "node_groups" {
  type        = any
  description = "Map of EKS node group configurations"
  default     = {}
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for EKS"
}

variable "managed_node_groups" {
  type        = any
  description = "Map of node group configurations"
  default     = {}
}

variable "eks_addons" {
  type = map(object({
    version                  = optional(string)
    service_account_role_arn = optional(string)
  }))

  default = {}
}
