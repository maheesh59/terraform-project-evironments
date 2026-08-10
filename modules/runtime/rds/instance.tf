resource "aws_db_instance" "this" {
  identifier_prefix = "${local.name_prefix}-rds-"

  # Engine Details
  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  # Storage Configuration
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type
  storage_encrypted     = true
  kms_key_id            = var.kms_key_arn != null ? var.kms_key_arn : aws_kms_key.rds[0].arn

  # Database Credentials & Networking
  db_name                = var.db_name
  username               = var.username
  password               = random_password.master_password.result
  port                   = var.port
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]
  parameter_group_name   = aws_db_parameter_group.this.name
  publicly_accessible    = var.publicly_accessible

  # High Availability & Failover
  multi_az = var.multi_az

  # Backups & Maintenance
  backup_retention_period   = var.backup_retention_period
  backup_window             = var.preferred_backup_window
  maintenance_window        = var.preferred_maintenance_window
  copy_tags_to_snapshot     = true
  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = "${local.name_prefix}-rds-final-snapshot"

  # Monitoring & Logging
  monitoring_interval             = var.monitoring_interval
  monitoring_role_arn             = var.monitoring_interval > 0 ? aws_iam_role.enhanced_monitoring[0].arn : null
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  # Lifecycle Protections
  auto_minor_version_upgrade = true

  tags = merge(
    local.default_tags,
    { Name = "${local.name_prefix}-rds" }
  )

  lifecycle {
    ignore_changes = [
      password,
      latest_restorable_time
    ]
  }
}
