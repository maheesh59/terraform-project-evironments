resource "aws_security_group" "jenkins" {
  name        = "${var.name}-sg"
  description = var.security_group_description
  vpc_id      = var.vpc_id

  ingress {
    description     = var.ingress_description
    from_port       = var.application_port
    to_port         = var.application_port
    protocol        = var.application_protocol
    security_groups = [var.alb_security_group_id]
  }

  egress {
    description = var.egress_description
    from_port   = var.egress_from_port
    to_port     = var.egress_to_port
    protocol    = var.egress_protocol
    cidr_blocks = var.egress_cidr_blocks
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name}-sg"
    }
  )
}
