resource "helm_release" "kafka" {
  name             = "kafka"
  chart            = "kafka"
  namespace        = "kafka"
  repository       = "oci://registry-1.docker.io/bitnamicharts"
  version          = "31.3.1"
  
  values = [file("${path.module}/values.yaml")]

  timeout = 600
}
