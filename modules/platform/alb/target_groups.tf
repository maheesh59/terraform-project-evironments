resource "aws_lb_target_group" "jenkins" {
  count = var.enable_jenkins ? 1 : 0

  name        = var.jenkins_target_group_name
  port        = var.jenkins_port
  protocol    = var.jenkins_target_group_protocol
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    enabled             = var.jenkins_health_check.enabled
    protocol            = var.jenkins_health_check.protocol
    port                = tostring(var.jenkins_port)
    path                = var.jenkins_health_check.path
    matcher             = var.jenkins_health_check.matcher
    interval            = var.jenkins_health_check.interval
    timeout             = var.jenkins_health_check.timeout
    healthy_threshold   = var.jenkins_health_check.healthy_threshold
    unhealthy_threshold = var.jenkins_health_check.unhealthy_threshold
  }

  tags = merge(
    var.common_tags,
    {
      Name = var.jenkins_target_group_name
    }
  )
}

resource "aws_lb_target_group_attachment" "jenkins" {
  count = var.enable_jenkins ? 1 : 0

  target_group_arn = aws_lb_target_group.jenkins[0].arn
  target_id        = module.jenkins[0].instance_id
  port             = var.jenkins_port
}

resource "aws_lb_target_group" "nexus" {
  count = var.enable_nexus ? 1 : 0

  name        = var.nexus_target_group_name
  port        = var.nexus_port
  protocol    = var.nexus_target_group_protocol
  target_type = var.target_type
  vpc_id      = var.vpc_id

  health_check {
    enabled             = var.nexus_health_check.enabled
    protocol            = var.nexus_health_check.protocol
    port                = tostring(var.nexus_port)
    path                = var.nexus_health_check.path
    matcher             = var.nexus_health_check.matcher
    interval            = var.nexus_health_check.interval
    timeout             = var.nexus_health_check.timeout
    healthy_threshold   = var.nexus_health_check.healthy_threshold
    unhealthy_threshold = var.nexus_health_check.unhealthy_threshold
  }

  tags = merge(
    var.common_tags,
    {
      Name = var.nexus_target_group_name
    }
  )
}

resource "aws_lb_target_group_attachment" "nexus" {
  count = var.enable_nexus ? 1 : 0

  target_group_arn = aws_lb_target_group.nexus[0].arn
  target_id        = module.nexus[0].instance_id
  port             = var.nexus_port
}

resource "aws_lb_target_group" "sonarqube" {
  count = var.enable_sonarqube ? 1 : 0

  name        = var.sonarqube_target_group_name
  port        = var.sonarqube_port
  protocol    = var.sonarqube_target_group_protocol
  target_type = var.target_type
  vpc_id      = var.vpc_id

  health_check {
    enabled             = var.sonarqube_health_check.enabled
    protocol            = var.sonarqube_health_check.protocol
    port                = tostring(var.sonarqube_port)
    path                = var.sonarqube_health_check.path
    matcher             = var.sonarqube_health_check.matcher
    interval            = var.sonarqube_health_check.interval
    timeout             = var.sonarqube_health_check.timeout
    healthy_threshold   = var.sonarqube_health_check.healthy_threshold
    unhealthy_threshold = var.sonarqube_health_check.unhealthy_threshold
  }

  tags = merge(
    var.common_tags,
    {
      Name = var.sonarqube_target_group_name
    }
  )
}

resource "aws_lb_target_group_attachment" "sonarqube" {
  count = var.enable_sonarqube ? 1 : 0

  target_group_arn = aws_lb_target_group.sonarqube[0].arn
  target_id        = module.sonarqube[0].instance_id
  port             = var.sonarqube_port
}
