resource "aws_security_group" "sonarqube" {
  name        = "${var.name}-sg"
  description = "Security group for SonarQube"
  vpc_id      = var.vpc_id

  ingress {
    description     = "SonarQube traffic from ALB"
    from_port       = 9000
    to_port         = 9000
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
    Name    = "${var.name}-sg"
    Service = "sonarqube"
  }
}
