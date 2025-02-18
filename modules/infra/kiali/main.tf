resource "helm_release" "kiali_operator" {
  name             = "kiali-operator"
  repository       = "https://kiali.org/helm-charts"
  chart            = "kiali-operator"
  namespace        = "kiali"
}

resource "kubernetes_manifest" "kiali_gateway" {
  manifest = yamldecode(file("${path.module}/gateway.yaml"))
}

locals {
  kiali_values = templatefile("${path.module}/kiali.yaml", {
    prometheus_url = "http://prometheus.monitoring.svc.cluster.local:9090"
    prometheus_username = ""
    prometheus_password = ""
    grafana_url = "http://grafana.monitoring.svc.cluster.local:3000"
    grafana_username = var.grafana_username
    grafana_password = var.grafana_password
  })
}

resource "kubernetes_manifest" "kiali" {  
  manifest = yamldecode(file("${path.module}/kiali.yaml"))
}
