resource "helm_release" "kafka" {
  name             = "kafka"
  chart            = "kafka"
  namespace        = "kafka"
  repository       = "https://charts.bitnami.com/bitnami"
  version          = "26.4.0"
  
  values = [file("${path.module}/values.yaml")]

  timeout = 600
}
