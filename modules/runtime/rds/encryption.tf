# Managed KMS Key generated dynamically if no external KMS Key ARN is supplied
resource "aws_kms_key" "rds" {
  count                   = var.kms_key_arn == null ? 1 : 0
  description             = "KMS Key for ${local.name_prefix} RDS storage encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = merge(
    local.default_tags,
    { Name = "${local.name_prefix}-rds-kms-key" }
  )
}

resource "aws_kms_alias" "rds" {
  count         = var.kms_key_arn == null ? 1 : 0
  name          = "alias/${local.name_prefix}-rds-key"
  target_key_id = aws_kms_key.rds[0].key_id
}

# Generates strong master database password stored directly in AWS Secrets Manager
resource "random_password" "master_password" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name_prefix             = "${local.name_prefix}-rds-credentials-"
  description             = "Master credentials for ${local.name_prefix} RDS"
  kms_key_id              = var.kms_key_arn != null ? var.kms_key_arn : aws_kms_key.rds[0].arn
  recovery_window_in_days = 0

  tags = local.default_tags
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    engine   = var.engine
    host     = aws_db_instance.this.address
    port     = var.port
    dbname   = var.db_name
    username = var.username
    password = random_password.master_password.result
  })
}
