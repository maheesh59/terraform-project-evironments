resource "aws_security_group" "alb" {
  name        = var.alb_security_group_name
  description = var.alb_security_group_description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.alb_ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    description = var.alb_egress_description
    from_port   = var.alb_egress_from_port
    to_port     = var.alb_egress_to_port
    protocol    = var.alb_egress_protocol
    cidr_blocks = var.alb_egress_cidr_blocks
  }

  tags = merge(
    var.common_tags,
    {
      Name = var.alb_security_group_name
    }
  )
}
