resource "aws_kms_key" "rds" {
  count = var.kms_key_arn == null ? 1 : 0

  description             = "KMS key for ${local.name_prefix} RDS encryption"
  deletion_window_in_days = var.kms_deletion_window_in_days
  enable_key_rotation     = var.kms_enable_key_rotation

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-rds-kms"
    }
  )
}

resource "aws_kms_alias" "rds" {
  count = var.kms_key_arn == null ? 1 : 0

  name          = "alias/${local.name_prefix}-rds"
  target_key_id = aws_kms_key.rds[0].key_id
}

resource "random_password" "master" {
  length           = var.password_length
  special          = var.password_special
  override_special = var.password_override_special
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name_prefix = "${local.name_prefix}-rds-credentials-"

  description = "Credentials for ${local.name_prefix} RDS"

  kms_key_id = (
    var.secrets_manager_kms_key_arn != null
    ? var.secrets_manager_kms_key_arn
    : var.kms_key_arn != null
    ? var.kms_key_arn
    : aws_kms_key.rds[0].arn
  )

  recovery_window_in_days = var.secret_recovery_window_in_days

  tags = local.common_tags
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id

  secret_string = jsonencode({
    engine   = var.engine
    host     = aws_db_instance.this.address
    port     = var.port
    dbname   = var.db_name
    username = var.username
    password = random_password.master.result
  })
}
