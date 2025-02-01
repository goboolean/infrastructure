resource "helm_release" "opentelemetry_collector" {
  name       = "opentelemetry-collector"
  chart      = "opentelemetry-collector"
  namespace  = "opentelemetry"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  version    = "0.75.0"

  values = [
    file("${path.module}/values.yaml")
  ]
}
