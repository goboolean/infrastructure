resource "helm_release" "kafka" {
  name             = "kafka"
  chart            = "kafka"
  namespace        = "kafka"
  repository       = "oci://registry-1.docker.io/bitnamicharts"
  version          = "31.3.1"
  
  values = [file("${path.module}/kafka-values.yaml")]

  timeout = 600
}

resource "helm_release" "kafka-exporter" {
  name             = "kafka-exporter"
  chart            = "prometheus-kafka-exporter"
  namespace        = "kafka"
  repository       = "https://prometheus-community.github.io/helm-charts"
  version          = "2.11.0"
  
  values = [file("${path.module}/exporter-values.yaml")]

  timeout = 600

  depends_on = [helm_release.kafka]
}
