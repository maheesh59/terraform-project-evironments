output "bucket_ids" {
  description = "Map of created S3 bucket IDs/names."
  value       = { for k, b in aws_s3_bucket.this : k => b.id }
}

output "bucket_arns" {
  description = "Map of created S3 bucket ARNs."
  value       = { for k, b in aws_s3_bucket.this : k => b.arn }
}

output "bucket_domain_names" {
  description = "Map of bucket domain names."
  value       = { for k, b in aws_s3_bucket.this : k => b.bucket_domain_name }
}
