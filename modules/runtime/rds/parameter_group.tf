resource "aws_db_parameter_group" "this" {
  name_prefix = "${local.name_prefix}-rds-pg-"

  family = var.family

  description = "Parameter group for ${local.name_prefix} RDS"

  dynamic "parameter" {
    for_each = var.parameters

    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-rds-pg"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}
