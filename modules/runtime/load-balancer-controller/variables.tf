# ==============================================================================
# AWS Load Balancer Controller
# Variables
# Location: modules/runtime/load-balancer-controller/variables.tf
# ==============================================================================

# ------------------------------------------------------------------------------
# Core
# ------------------------------------------------------------------------------

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name such as test, dev, or prod"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster is deployed"
  type        = string
}

# ------------------------------------------------------------------------------
# Controller
# ------------------------------------------------------------------------------

variable "enable_aws_load_balancer_controller" {
  description = "Enable or disable AWS Load Balancer Controller"
  type        = bool
  default     = true
}

variable "lb_controller_replica_count" {
  description = "Number of controller replicas"
  type        = number
  default     = 1

  validation {
    condition     = var.lb_controller_replica_count >= 1
    error_message = "Replica count must be at least 1."
  }
}

# ------------------------------------------------------------------------------
# Helm
# ------------------------------------------------------------------------------

variable "lb_controller_helm_release_name" {
  description = "Helm release name"
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "lb_controller_helm_repo" {
  description = "Helm repository URL"
  type        = string
  default     = "https://aws.github.io/eks-charts"
}

variable "lb_controller_helm_chart" {
  description = "Helm chart name"
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "lb_controller_chart_version" {
  description = "AWS Load Balancer Controller Helm chart version"
  type        = string
  default     = "1.7.1"
}

variable "lb_controller_namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "kube-system"
}

variable "lb_controller_image_tag" {
  description = "AWS Load Balancer Controller image tag"
  type        = string
  default     = "v2.7.1"
}

# ------------------------------------------------------------------------------
# Helm Lifecycle
# ------------------------------------------------------------------------------

variable "lb_controller_helm_wait" {
  description = "Wait for Helm resources to become ready"
  type        = bool
  default     = true
}

variable "lb_controller_helm_wait_for_jobs" {
  description = "Wait for Helm jobs"
  type        = bool
  default     = true
}

variable "lb_controller_helm_timeout" {
  description = "Helm deployment timeout in seconds"
  type        = number
  default     = 600
}

variable "lb_controller_helm_cleanup_on_fail" {
  description = "Clean up Helm resources when installation fails"
  type        = bool
  default     = true
}

# ------------------------------------------------------------------------------
# Resources
# ------------------------------------------------------------------------------

variable "lb_controller_cpu_request" {
  description = "CPU request"
  type        = string
  default     = "100m"
}

variable "lb_controller_memory_request" {
  description = "Memory request"
  type        = string
  default     = "128Mi"
}

variable "lb_controller_cpu_limit" {
  description = "CPU limit"
  type        = string
  default     = "200m"
}

variable "lb_controller_memory_limit" {
  description = "Memory limit"
  type        = string
  default     = "256Mi"
}

# ------------------------------------------------------------------------------
# Pod Disruption Budget
# ------------------------------------------------------------------------------

variable "lb_controller_pdb_max_unavailable" {
  description = "Maximum unavailable controller pods"
  type        = number
  default     = 1
}

# ------------------------------------------------------------------------------
# Pod Anti-Affinity
# ------------------------------------------------------------------------------

variable "lb_controller_pod_anti_affinity_weight" {
  description = "Pod anti-affinity weight"
  type        = number
  default     = 100
}

variable "lb_controller_topology_key" {
  description = "Topology key"
  type        = string
  default     = "kubernetes.io/hostname"
}

variable "lb_controller_app_name_label_key" {
  description = "Pod label key used by anti-affinity"
  type        = string
  default     = "app.kubernetes.io/name"
}

variable "lb_controller_app_name_label_operator" {
  description = "Pod label selector operator"
  type        = string
  default     = "In"
}

variable "lb_controller_app_name_label_value" {
  description = "Pod label value"
  type        = string
  default     = "aws-load-balancer-controller"
}

# ------------------------------------------------------------------------------
# Service Account
# ------------------------------------------------------------------------------

variable "lb_controller_service_account" {
  description = "Kubernetes ServiceAccount name"
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "lb_controller_service_account_create" {
  description = "Allow Helm to create the ServiceAccount"
  type        = bool
  default     = true
}

variable "lb_controller_use_sts_regional_endpoints" {
  description = "Use regional STS endpoints"
  type        = bool
  default     = true
}

# ------------------------------------------------------------------------------
# IAM
# ------------------------------------------------------------------------------

variable "lb_controller_iam_role_suffix" {
  description = "IAM role name suffix"
  type        = string
  default     = "lb-controller-irsa"
}

variable "lb_controller_iam_policy_suffix" {
  description = "IAM policy name suffix"
  type        = string
  default     = "lb-controller-policy"
}

variable "iam_role_name" {
  description = "Optional explicit IAM role name"
  type        = string
  default     = ""
}

variable "iam_policy_name" {
  description = "Optional explicit IAM policy name"
  type        = string
  default     = ""
}

variable "lb_controller_iam_role_description" {
  description = "IAM role description"
  type        = string
  default     = "IAM role for AWS Load Balancer Controller"
}

variable "lb_controller_iam_policy_description" {
  description = "IAM policy description"
  type        = string
  default     = "IAM policy for AWS Load Balancer Controller"
}

# ------------------------------------------------------------------------------
# WAF / Shield
# ------------------------------------------------------------------------------

variable "enable_waf" {
  description = "Enable AWS WAF Classic permissions"
  type        = bool
  default     = false
}

variable "enable_wafv2" {
  description = "Enable AWS WAFv2 permissions"
  type        = bool
  default     = false
}

variable "enable_shield" {
  description = "Enable AWS Shield Advanced permissions"
  type        = bool
  default     = false
}

# ------------------------------------------------------------------------------
# Logging
# ------------------------------------------------------------------------------

variable "lb_controller_log_level" {
  description = "Controller log level"
  type        = string
  default     = "info"

  validation {
    condition = contains(
      ["info", "debug", "error"],
      var.lb_controller_log_level
    )

    error_message = "Log level must be info, debug, or error."
  }
}

# ------------------------------------------------------------------------------
# OIDC / IRSA
# ------------------------------------------------------------------------------

variable "oidc_provider_arn" {
  description = "EKS OIDC provider ARN"
  type        = string
}

variable "oidc_provider_url" {
  description = "EKS OIDC provider URL"
  type        = string
}

variable "oidc_audience" {
  description = "OIDC audience"
  type        = string
  default     = "sts.amazonaws.com"
}

# ------------------------------------------------------------------------------
# Tags
# ------------------------------------------------------------------------------

variable "managed_by_tag" {
  description = "ManagedBy tag value"
  type        = string
  default     = "Terraform"
}

variable "lb_controller_component_tag" {
  description = "Component tag"
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "additional_tags" {
  description = "Additional resource tags"
  type        = map(string)
  default     = {}
}
