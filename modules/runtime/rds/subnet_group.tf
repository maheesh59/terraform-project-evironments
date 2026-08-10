resource "aws_db_subnet_group" "this" {
  name_prefix = "${local.name_prefix}-rds-sn-group-"
  description = "Subnet group for ${local.name_prefix} RDS instance"
  subnet_ids  = var.subnet_ids

  tags = merge(
    local.default_tags,
    { Name = "${local.name_prefix}-rds-subnet-group" }
  )

  lifecycle {
    create_before_destroy = true
  }
}
