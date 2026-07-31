output "key_arn" {
  description = "Amazon Resource Name (ARN) of the key"
  value       = aws_kms_key.this.arn
}

output "key_id" {
  description = "Globally unique identifier for the key"
  value       = aws_kms_key.this.key_id
}

output "alias_arn" {
  description = "ARN of the key alias"
  value       = try(aws_kms_alias.this[0].arn, null)
}

output "alias_name" {
  description = "Display name of the key alias"
  value       = try(aws_kms_alias.this[0].name, null)
}
