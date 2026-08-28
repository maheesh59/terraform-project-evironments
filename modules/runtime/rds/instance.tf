resource "aws_db_instance" "this" {
  identifier_prefix = "${local.name_prefix}-rds-"

  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type

  storage_encrypted = var.storage_encrypted

  kms_key_id = (
    var.kms_key_arn != null
    ? var.kms_key_arn
    : aws_kms_key.rds[0].arn
  )

  db_name  = var.db_name
  username = var.username
  password = var.password
  port     = var.port

  db_subnet_group_name = aws_db_subnet_group.this.name

  vpc_security_group_ids = [
    aws_security_group.this.id
  ]

  publicly_accessible = var.publicly_accessible

  parameter_group_name = aws_db_parameter_group.this.name

  multi_az = var.multi_az

  backup_retention_period = var.backup_retention_period

  backup_window     = var.preferred_backup_window
  maintenance_window = var.preferred_maintenance_window

  copy_tags_to_snapshot = var.copy_tags_to_snapshot

  deletion_protection = var.deletion_protection

  skip_final_snapshot = var.skip_final_snapshot

  final_snapshot_identifier = (
    var.skip_final_snapshot
    ? null
    : "${local.name_prefix}-rds-final-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  )

  monitoring_interval = var.monitoring_interval

  monitoring_role_arn = (
    var.monitoring_interval > 0
    ? aws_iam_role.enhanced_monitoring[0].arn
    : null
  )

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  auto_minor_version_upgrade = var.auto_minor_version_upgrade


  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-rds"
    }
  )

  lifecycle {
    ignore_changes = [
      password
    ]
  }
}
