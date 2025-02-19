resource "helm_release" "kiali_operator" {
  name             = "kiali-operator"
  repository       = "https://kiali.org/helm-charts"
  chart            = "kiali-operator"
  namespace        = "kiali"
  version          = "2.5.0"

  values = [templatefile("${path.module}/values.yaml", {
    prometheus_url = "http://kube-prometheus-stack-prometheus.monitoring.svc.cluster.local:9090"
    grafana_external_url = "https://grafana.goboolean.io"
    grafana_internal_url = "http://kube-prometheus-stack-grafana.monitoring.svc.cluster.local:80"
    grafana_username = var.grafana_username
    grafana_password = var.grafana_password
  })]
}

resource "kubernetes_manifest" "kiali_gateway" {
  manifest = yamldecode(file("${path.module}/gateway.yaml"))
}
