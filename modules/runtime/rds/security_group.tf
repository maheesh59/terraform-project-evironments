resource "aws_security_group" "this" {
  name_prefix = "${local.name_prefix}-rds-sg-"
  description = "Security group for ${local.name_prefix} RDS instance"
  vpc_id      = var.vpc_id

  tags = merge(
    local.default_tags,
    { Name = "${local.name_prefix}-rds-sg" }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "from_sgs" {
  count                        = length(var.allowed_security_group_ids)
  security_group_id            = aws_security_group.this.id
  referenced_security_group_id = var.allowed_security_group_ids[count.index]
  from_port                    = var.port
  to_port                      = var.port
  ip_protocol                  = "tcp"
  description                  = "Allow traffic from application security group"
}

resource "aws_vpc_security_group_ingress_rule" "from_cidrs" {
  count             = length(var.allowed_cidr_blocks) > 0 ? 1 : 0
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = var.allowed_cidr_blocks[0] # Expand via dynamic iteration if needed
  from_port         = var.port
  to_port           = var.port
  ip_protocol       = "tcp"
  description       = "Allow traffic from authorized CIDRs"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}
