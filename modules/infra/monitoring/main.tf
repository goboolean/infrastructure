locals {
  values_yaml = templatefile("${path.module}/values.yaml", {
    grafana_username = var.grafana_username
    grafana_password = var.grafana_password
  })
}

resource "helm_release" "prometheus" {
  name             = "prometheus"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  repository       = "https://prometheus-community.github.io/helm-charts"
  version          = "68.4.5"
  
  values = [local.values_yaml]

  timeout = 600
}

resource "kubernetes_manifest" "prometheus-gateway" {
  manifest = yamldecode(file("${path.module}/prometheus-gateway.yaml"))
  depends_on = [helm_release.prometheus]
}

resource "kubernetes_manifest" "grafana-gateway" {
  manifest = yamldecode(file("${path.module}/grafana-gateway.yaml"))
  depends_on = [helm_release.prometheus]
}
