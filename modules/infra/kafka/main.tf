resource "helm_release" "kafka" {
  name             = "kafka"
  chart            = "kafka"
  namespace        = "kafka"
  repository       = "https://charts.bitnami.com/bitnami"
  version          = "31.3.1"
  
  values = [file("${path.module}/values.yaml")]

  timeout = 600
}
