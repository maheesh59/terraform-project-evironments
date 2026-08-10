resource "aws_eks_node_group" "this" {
  for_each = var.node_groups

  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-${each.key}-node-group"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.private_subnet_ids

  # This tells EKS to use the official 1.30 AL2023 AMI automatically
  ami_type       = lookup(each.value, "ami_type", "AL2023_x86_64_STANDARD")
  capacity_type  = lookup(each.value, "capacity_type", "ON_DEMAND")
  instance_types = lookup(each.value, "instance_types", ["t3.medium"])

  launch_template {
    id      = aws_launch_template.nodes.id
    version = aws_launch_template.nodes.latest_version
  }  

  scaling_config {
    desired_size = lookup(each.value, "desired_size", 2)
    min_size     = lookup(each.value, "min_size", 1)
    max_size     = lookup(each.value, "max_size", 3)
  }

  labels = lookup(each.value, "labels", {})

  tags = merge(
    local.common_tags,
    {
      Name = "${var.cluster_name}-${each.key}-node-group"
    }
  )
}
