resource "kubernetes_manifest" "istio_gateway" {
  manifest = yamldecode(file("${path.module}/gateway.yaml"))
}
