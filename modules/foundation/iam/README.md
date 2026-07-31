# AWS IAM Foundation Module

A modular, enterprise-grade IAM module supporting IAM roles, instance profiles, managed and inline policy attachments, and OIDC federated trust policies.

## File Structure
- `roles.tf`: IAM Role and Instance Profile resources.
- `policies.tf`: Managed policy attachments and custom inline policy definitions.
- `oidc.tf`: OIDC web identity trust document definitions.
- `data.tf`: Standard service/IAM trust policy definitions.
- `variables.tf`: Input attributes and configurations.
- `outputs.tf`: Exported attributes.
- `locals.tf`: Module tagging metadata.
- `versions.tf`: Constraints on Terraform and provider engine versions.

## Example: GitHub Actions OIDC Role

```hcl
module "github_actions_role" {
  source = "../../modules/foundation/iam"

  role_name         = "github-actions-deployer"
  enable_oidc       = true
  oidc_provider_arn = "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"
  oidc_subjects     = ["repo:my-org/my-repo:environment:production"]

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/PowerUserAccess"
  ]
}
