resource "aws_lb" "this" {
  name               = var.alb_name
  internal           = var.alb_internal
  load_balancer_type = var.alb_load_balancer_type

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = var.public_subnet_ids

  enable_deletion_protection = var.alb_deletion_protection

  tags = merge(
    var.common_tags,
    {
      Name = var.alb_name
    }
  )
}
