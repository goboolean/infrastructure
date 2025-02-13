resource "helm_release" "dex" {
  name       = "dex"
  repository = "https://charts.dexidp.io"
  chart      = "dex"
  version    = "0.20.0"
  namespace  = "dex"

  wait = true

  values = [
    file("${path.module}/values.yaml")
  ]
}

resource "kubernetes_manifest" "dex_gateway" {
  manifest = yamldecode(file("${path.module}/gateway.yaml"))
}
