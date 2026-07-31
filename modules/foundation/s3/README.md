# AWS S3 Foundation Module

This module provisions an S3 bucket following AWS security best practices (v4+ provider syntax).

## Features
- Managed Server-Side Encryption (SSE-S3 or KMS)
- Public Access Block enforced by default
- Configurable Object Versioning
- Lifecycle transitions and non-current version expiration
- Custom bucket policy support

## Usage

```hcl
module "s3_bucket" {
  source = "../../modules/foundation/s3"

  bucket_name       = "my-app-logs-production-12345"
  enable_versioning = true

  tags = {
    Environment = "production"
    Owner       = "devops"
  }
}
