variable "environment" {
  type        = string
  description = "Target deployment environment (e.g., prod, staging)"
}

variable "aws_region" {
  type        = string
  description = "AWS Region where resources are deployed"
}

variable "cluster_name" {
  type        = string
  description = "Name of the target EKS cluster"
}

variable "cluster_endpoint" {
  type        = string
  description = "EKS cluster control plane API endpoint"
}

variable "cluster_primary_security_group_id" {
  type        = string
  description = "EKS primary security group ID for nodes"
  default     = null
}

variable "oidc_provider_arn" {
  type        = string
  description = "ARN of the cluster OIDC provider for IRSA"
}

variable "karpenter_version" {
  type        = string
  description = "Karpenter Helm chart version"
}

variable "enable_spot_termination_handling" {
  type        = bool
  description = "Enable EventBridge and SQS interruption handling for Spot instances"
  default     = true
}

variable "extra_tags" {
  type        = map(string)
  description = "Additional tags for resources"
  default     = {}
}

variable "sqs_message_retention_seconds" {
  type        = number
  description = "The duration (in seconds) for which SQS retains spot termination messages."
}


