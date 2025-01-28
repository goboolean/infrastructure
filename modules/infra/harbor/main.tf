resource "helm_release" "harbor" {
  name       = "harbor"
  repository = "https://helm.goharbor.io"
  chart      = "harbor"
  namespace        = "harbor"
  create_namespace = true
  version          = "1.15.0"

  values = [file("${path.module}/values.yaml")]
}

resource "kubernetes_manifest" "harbor_gateway" {
  manifest = yamldecode(file("${path.module}/gateway.yaml"))
}
