resource "aws_security_group" "this" {
  name_prefix = "${local.name_prefix}-rds-sg-"

  description = var.security_group_description

  vpc_id = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-rds-sg"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "from_security_groups" {
  for_each = var.allowed_security_group_ids

  security_group_id = aws_security_group.this.id

  referenced_security_group_id = each.value

  from_port = var.port
  to_port   = var.port

  ip_protocol = var.ingress_protocol

  description = var.security_group_ingress_description
}

resource "aws_vpc_security_group_ingress_rule" "from_cidrs" {
  for_each = toset(nonsensitive(var.allowed_cidr_blocks))

  security_group_id = aws_security_group.this.id

  cidr_ipv4 = each.value

  from_port = var.port
  to_port   = var.port

  ip_protocol = var.ingress_protocol

  description = var.cidr_ingress_description
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.this.id

  cidr_ipv4 = var.egress_cidr_block

  ip_protocol = var.egress_protocol

  description = var.egress_description
}
