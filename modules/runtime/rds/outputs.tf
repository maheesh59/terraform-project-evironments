output "db_instance_id" {
  description = "RDS instance ID"
  value       = aws_db_instance.this.id
}

output "db_instance_arn" {
  description = "RDS instance ARN"
  value       = aws_db_instance.this.arn
}

output "db_instance_address" {
  description = "RDS DNS address"
  value       = aws_db_instance.this.address
}

output "db_instance_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.this.endpoint
}

output "db_instance_port" {
  description = "RDS port"
  value       = aws_db_instance.this.port
}

output "db_subnet_group_name" {
  description = "RDS subnet group"
  value       = aws_db_subnet_group.this.name
}

output "security_group_id" {
  description = "RDS security group ID"
  value       = aws_security_group.this.id
}

output "secretsmanager_secret_arn" {
  description = "Secrets Manager ARN containing RDS credentials"
  value       = aws_secretsmanager_secret.db_credentials.arn
}

output "kms_key_arn" {
  description = "KMS key used by RDS"
  value = (
    var.kms_key_arn != null
    ? var.kms_key_arn
    : aws_kms_key.rds[0].arn
  )
}

output "monitoring_role_arn" {
  description = "RDS Enhanced Monitoring role ARN"
  value = (
    var.monitoring_interval > 0
    ? aws_iam_role.enhanced_monitoring[0].arn
    : null
  )
}
