# AWS Secrets Manager Foundation Module

A granular, production-ready module for managing AWS Secrets Manager secrets, version payloads, and rotation rules.

## File Breakdown
- `secrets.tf`: Container, version payloads, and rotation rules.
- `resource_policy.tf`: Resource-based policy attachments.
- `data.tf`: Local environment context (AWS Account, Region).
- `variables.tf`: Input schemas and defaults.
- `outputs.tf`: Exported attributes.
- `locals.tf`: Tag generation logic.
- `versions.tf`: Engine and provider bounds.

## Quick Example

```hcl
module "app_secret" {
  source = "../../modules/foundation/secrets_manager"

  name        = "production/app/db"
  description = "Database master key"
  kms_key_id  = "arn:aws:kms:us-east-1:123456789012:key/your-key-id"

  secret_key_values = {
    username = "db_user"
    password = "SuperSecretPassword123!"
  }

  tags = {
    Environment = "production"
  }
}
