resource "kubernetes_manifest" "kafka-jmx-config" {
  manifest = yamldecode(file("${path.module}/kafka-jmx-config.yaml"))
}

resource "helm_release" "kafka" {
  name             = "kafka"
  chart            = "kafka"
  namespace        = "kafka"
  repository       = "oci://registry-1.docker.io/bitnamicharts"
  version          = "31.3.1"
  
  values = [file("${path.module}/kafka-values.yaml")]

  timeout = 600

  depends_on = [ kubernetes_manifest.kafka-jmx-config ]
}

resource "helm_release" "prometheus-kafka-exporter" {
  name             = "prometheus-kafka-exporter"
  chart            = "prometheus-kafka-exporter"
  namespace        = "kafka"
  repository       = "https://prometheus-community.github.io/helm-charts"
  version          = "2.11.0"
  
  values = [file("${path.module}/exporter-values.yaml")]

  timeout = 600

  depends_on = [helm_release.kafka]
}

resource "helm_release" "kafka-ui" {
  name             = "kafka-ui"
  chart            = "kafka-ui"
  namespace        = "kafka"
  repository       = "https://provectus.github.io/kafka-ui-charts"
  version          = "0.7.6"

  values = [file("${path.module}/kafka-ui-values.yaml")]
}

resource "kubernetes_manifest" "kafka-ui-gateway" {
  manifest = yamldecode(file("${path.module}/gateway.yaml"))
  depends_on = [helm_release.kafka-ui]
}
