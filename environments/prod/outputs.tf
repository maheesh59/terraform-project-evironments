output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "kms_key_arn" {
  description = "ARN of KMS Key"
  value       = module.kms.key_arn
}

output "s3_bucket_name" {
  description = "S3 Bucket Name"
  value       = module.s3_assets.bucket_id
}

output "secret_arn" {
  description = "Secrets Manager ARN"
  value       = module.secrets.secret_arn
}

output "iam_role_arn" {
  description = "IAM Role ARN"
  value       = module.iam_role.role_arn
}
