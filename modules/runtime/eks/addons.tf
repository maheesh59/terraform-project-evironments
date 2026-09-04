resource "aws_eks_addon" "addons" {
  for_each = var.eks_addons

  cluster_name = aws_eks_cluster.main.name

  addon_name    = each.key
  addon_version = try(each.value.version, null)

  service_account_role_arn = each.key == "aws-ebs-csi-driver" ? aws_iam_role.ebs_csi.arn : try(
    each.value.service_account_role_arn,
    null
  )

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = local.common_tags
}
