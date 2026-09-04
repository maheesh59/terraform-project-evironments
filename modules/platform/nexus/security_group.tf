resource "aws_security_group" "nexus" {
  name        = "${var.name}-sg"
  description = "Security group for Nexus Repository"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Nexus UI and API from ALB"
    from_port       = var.nexus_port
    to_port         = var.nexus_port
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    description = "Outbound access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name}-sg"
    Application = "Nexus"
    Environment = var.environment
  }
}
