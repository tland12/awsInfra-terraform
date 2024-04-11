resource "kubernetes_namespace" "prometheus-namespace" {
  depends_on = [
    aws_eks_node_group.was
  ]
  metadata {
    name = "prometheus"
  }
}
resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.prometheus-namespace.id
  create_namespace = true
  version    = "45.7.1"
  values = [
    file("prometheus_values.yaml")
  ]
  timeout = 2000

  set {
    name  = "podSecurityPolicy.enabled"
    value = true
  }

  set {
    name  = "server.persistentVolume.enabled"
    value = false
  }

  set {
    name = "server\\.resources"
    value = yamlencode({
      limits = {
        cpu    = "200m"
        memory = "50Mi"
      }
      requests = {
        cpu    = "100m"
        memory = "30Mi"
      }
    })
  }
}
