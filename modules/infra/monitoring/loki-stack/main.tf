resource "helm_release" "loki" {
  name             = "loki"
  chart            = "loki"
  namespace        = "monitoring"
  repository       = "https://grafana.github.io/helm-charts"
  version          = "6.25.0"
  
  values = [templatefile("${path.module}/loki-values.yaml", {
    project_id = var.project_id
  })]

  timeout = 600
}

resource "helm_release" "promtail" {
  name             = "promtail"
  chart            = "promtail"
  namespace        = "monitoring"
  repository       = "https://grafana.github.io/helm-charts"
  version          = "6.16.6"
  
  values = [file("${path.module}/promtail-values.yaml")]

  timeout = 600

  depends_on = [helm_release.loki]
}
