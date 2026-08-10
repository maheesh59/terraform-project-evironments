resource "kubectl_manifest" "karpenter_node_class" {
  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1
    kind: EC2NodeClass
    metadata:
      name: default
    spec:
      amiFamily: AL2023
      role: "${aws_iam_role.node.name}"

      subnetSelectorTerms:
        - tags:
            karpenter.sh/discovery: "${var.cluster_name}"

      securityGroupSelectorTerms:
        - tags:
            karpenter.sh/discovery: "${var.cluster_name}"
  YAML

  depends_on = [
    helm_release.karpenter,
    aws_iam_role.node
  ]
}
