# ==============================================================================
# AWS Load Balancer Controller
# Local Variables
# Location: modules/runtime/load-balancer-controller/locals.tf
# ==============================================================================

locals {

  # --------------------------------------------------------------------------
  # Common Naming
  # --------------------------------------------------------------------------

  name_prefix = "${var.project_name}-${var.environment}"

  # --------------------------------------------------------------------------
  # IAM Names
  # --------------------------------------------------------------------------

  iam_role_name = (
    var.iam_role_name != ""
    ? var.iam_role_name
    : "${local.name_prefix}-${var.lb_controller_iam_role_suffix}"
  )

  iam_policy_name = (
    var.iam_policy_name != ""
    ? var.iam_policy_name
    : "${local.name_prefix}-${var.lb_controller_iam_policy_suffix}"
  )

  # --------------------------------------------------------------------------
  # OIDC Configuration
  # --------------------------------------------------------------------------

  oidc_provider_url = var.oidc_provider_url
  oidc_provider_arn = var.oidc_provider_arn

  # Remove https:// because IAM condition keys require the provider URL
  # without the protocol.
  oidc_provider_id = replace(
    local.oidc_provider_url,
    "https://",
    ""
  )

  # --------------------------------------------------------------------------
  # Kubernetes Service Account
  # --------------------------------------------------------------------------

  service_account_name = var.lb_controller_service_account

  service_account_namespace = var.lb_controller_namespace

  service_account_full_name = (
    "system:serviceaccount:${local.service_account_namespace}:${local.service_account_name}"
  )

  # --------------------------------------------------------------------------
  # Helm Configuration
  # --------------------------------------------------------------------------

  helm_release_name = var.lb_controller_helm_release_name
  helm_repository   = var.lb_controller_helm_repo
  helm_chart        = var.lb_controller_helm_chart

  # --------------------------------------------------------------------------
  # Helm Service Account Annotations
  # --------------------------------------------------------------------------

  lb_controller_role_arn_key = "eks.amazonaws.com/role-arn"

  lb_controller_sts_endpoint_key = "eks.amazonaws.com/sts-regional-endpoints"

  # --------------------------------------------------------------------------
  # Common Tags
  # --------------------------------------------------------------------------

  common_tags = merge(
    {
      Name        = local.name_prefix
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = var.managed_by_tag
      Component   = var.lb_controller_component_tag
    },
    var.additional_tags
  )

  # --------------------------------------------------------------------------
  # AWS Account
  # --------------------------------------------------------------------------

  account_id = data.aws_caller_identity.current.account_id

  aws_region = var.aws_region
}
