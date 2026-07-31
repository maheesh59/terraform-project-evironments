output "secret_arns" {
  description = "Map of secret ARNs keyed by purpose."
  value       = { for k, s in aws_secretsmanager_secret.this : k => s.arn }
}

output "secret_ids" {
  description = "Map of secret IDs/names keyed by purpose."
  value       = { for k, s in aws_secretsmanager_secret.this : k => s.id }
}

output "secret_names" {
  description = "Map of secret names keyed by purpose."
  value       = { for k, s in aws_secretsmanager_secret.this : k => s.name }
}
