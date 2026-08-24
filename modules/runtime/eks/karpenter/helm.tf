resource "helm_release" "karpenter" {
  namespace        = local.namespace
  create_namespace = false

  name       = "karpenter"
  repository = "oci://public.ecr.aws/karpenter"
  chart      = "karpenter"
  version    = var.karpenter_version

  set {
    name  = "settings.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "settings.clusterEndpoint"
    value = var.cluster_endpoint
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.controller.arn
  }

  set {
    name  = "settings.interruptionQueue"
    value = var.enable_spot_termination_handling ? aws_sqs_queue.interruption[0].name : ""
  }

  set {
    name  = "postInstallHook.image.repository"
    value = "registry.k8s.io/kubectl"
  }

  set {
    name  = "postInstallHook.image.tag"
    value = "1.30.14"
  }

  set {
    name  = "postInstallHook.image.digest"
    value = ""
  }

  depends_on = [
    aws_iam_role_policy.controller
  ]
}
