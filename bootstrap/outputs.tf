output "s3_bucket_name" {
  value       = aws_s3_bucket.state_bucket.id
  description = "Use this value inside backend.tf for your environments"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.lock_table.id
  description = "DynamoDB lock table name"
}

output "kms_key_arn" {
  value       = aws_kms_key.state_key.arn
  description = "KMS Key ARN used for state encryption"
}
