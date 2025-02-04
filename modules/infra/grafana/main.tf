locals {
  values_yaml = templatefile("${path.module}/values.yaml", {
    username = var.grafana_username
    password = var.grafana_password
    influxdb_token = var.influxdb_token
  })
}

resource "helm_release" "grafana" {
  name             = "grafana"
  chart            = "grafana"
  namespace        = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  version          = "8.9.0"
  
  values = [local.values_yaml]

  timeout = 600
}

resource "kubernetes_manifest" "grafana-gateway" {
  manifest = yamldecode(file("${path.module}/gateway.yaml"))
  depends_on = [helm_release.grafana]
}
