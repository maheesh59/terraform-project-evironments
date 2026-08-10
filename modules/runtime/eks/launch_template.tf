resource "aws_launch_template" "nodes" {
  name_prefix            = "${local.name_prefix}-node-lt-"
  description            = "Custom launch template for EKS managed node group"
  update_default_version = true

  vpc_security_group_ids = [aws_security_group.nodes.id]

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 50
      volume_type           = "gp3"
      encrypted             = true
      kms_key_id            = aws_kms_key.eks.arn
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags          = merge(local.common_tags, { Name = "${local.name_prefix}-managed-node" })
  }

  lifecycle {
    create_before_destroy = true
  }
}
