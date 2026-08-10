resource "kubectl_manifest" "karpenter_node_pool" {
  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1
    kind: NodePool

    metadata:
      name: default

    spec:
      template:
        spec:
          nodeClassRef:
            name: default

          requirements:
            - key: karpenter.sh/capacity-type
              operator: In
              values:
                - spot
                - on-demand

            - key: kubernetes.io/arch
              operator: In
              values:
                - amd64

            - key: karpenter.k8s.aws/instance-category
              operator: In
              values:
                - c
                - m
                - r

      limits:
        cpu: "1000"

      disruption:
        consolidationPolicy: WhenEmptyOrUnderutilized
        consolidateAfter: 1m

        budgets:
          - nodes: "10%"
  YAML

  depends_on = [
    kubectl_manifest.karpenter_node_class
  ]
}
