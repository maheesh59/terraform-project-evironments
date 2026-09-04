resource "aws_lb_listener" "jenkins" {
  count = var.enable_jenkins ? 1 : 0

  load_balancer_arn = aws_lb.this.arn
  port              = var.jenkins_listener_port
  protocol          = var.jenkins_listener_protocol

  default_action {
    type             = var.listener_action_type
    target_group_arn = aws_lb_target_group.jenkins[0].arn
  }
}

resource "aws_lb_listener" "nexus" {
  count = var.enable_nexus ? 1 : 0

  load_balancer_arn = aws_lb.this.arn
  port              = var.nexus_listener_port
  protocol          = var.nexus_listener_protocol

  default_action {
    type             = var.listener_action_type
    target_group_arn = aws_lb_target_group.nexus[0].arn
  }
}

resource "aws_lb_listener" "sonarqube" {
  count = var.enable_sonarqube ? 1 : 0

  load_balancer_arn = aws_lb.this.arn
  port              = var.sonarqube_listener_port
  protocol          = var.sonarqube_listener_protocol

  default_action {
    type             = var.listener_action_type
    target_group_arn = aws_lb_target_group.sonarqube[0].arn
  }
}
