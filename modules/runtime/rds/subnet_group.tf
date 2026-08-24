resource "aws_db_subnet_group" "this" {
  name_prefix = "${local.name_prefix}-rds-subnet-"

  description = var.subnet_group_description

  subnet_ids = var.subnet_ids

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-rds-subnet"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}
