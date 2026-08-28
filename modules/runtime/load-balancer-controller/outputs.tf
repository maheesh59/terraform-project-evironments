# ==============================================================================
# AWS Load Balancer Controller
# Outputs
# Location: modules/runtime/load-balancer-controller/outputs.tf
# ==============================================================================

# ------------------------------------------------------------------------------
# IAM
# ------------------------------------------------------------------------------

output "lb_controller_iam_role_arn" {
  description = "ARN of the Load Balancer Controller IAM role"

  value = try(
    aws_iam_role.lb_controller[0].arn,
    null
  )
}

output "lb_controller_iam_role_name" {
  description = "Name of the Load Balancer Controller IAM role"

  value = try(
    aws_iam_role.lb_controller[0].name,
    null
  )
}

output "lb_controller_iam_policy_arn" {
  description = "ARN of the Load Balancer Controller IAM policy"

  value = try(
    aws_iam_policy.lb_controller[0].arn,
    null
  )
}

output "lb_controller_iam_policy_name" {
  description = "Name of the Load Balancer Controller IAM policy"

  value = try(
    aws_iam_policy.lb_controller[0].name,
    null
  )
}

# ------------------------------------------------------------------------------
# Helm
# ------------------------------------------------------------------------------

output "lb_controller_helm_release_name" {
  description = "Helm release name"

  value = try(
    helm_release.lb_controller[0].name,
    null
  )
}

output "lb_controller_helm_release_namespace" {
  description = "Helm release namespace"

  value = try(
    helm_release.lb_controller[0].namespace,
    null
  )
}

output "lb_controller_helm_release_version" {
  description = "Installed Helm chart version"

  value = try(
    helm_release.lb_controller[0].version,
    null
  )
}

output "lb_controller_helm_release_status" {
  description = "Helm release status"

  value = try(
    helm_release.lb_controller[0].status,
    null
  )
}

# ------------------------------------------------------------------------------
# Service Account
# ------------------------------------------------------------------------------

output "lb_controller_service_account_name" {
  description = "Kubernetes ServiceAccount name"

  value = var.lb_controller_service_account
}

output "lb_controller_service_account_namespace" {
  description = "Kubernetes ServiceAccount namespace"

  value = var.lb_controller_namespace
}

# ------------------------------------------------------------------------------
# OIDC
# ------------------------------------------------------------------------------

output "oidc_provider_arn" {
  description = "EKS OIDC provider ARN"

  value = local.oidc_provider_arn
}

output "oidc_provider_url" {
  description = "EKS OIDC provider URL"

  value = local.oidc_provider_url
}

# ------------------------------------------------------------------------------
# Cluster
# ------------------------------------------------------------------------------

output "cluster_name" {
  description = "EKS cluster name"

  value = var.cluster_name
}

output "aws_region" {
  description = "AWS region"

  value = local.aws_region
}

output "aws_account_id" {
  description = "AWS account ID"

  value = local.account_id
}
