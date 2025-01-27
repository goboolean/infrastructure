resource "helm_release" "harbor" {
  name       = "harbor"
  repository = "https://helm.goharbor.io"
  chart      = "harbor"
  namespace        = "harbor"
  create_namespace = true
  version          = "1.15.0"

  values = [file("${path.module}/values.yaml")]

  set {
    name  = "configmap_checksum"
    value = sha256(file("${path.module}/values.yaml"))
  }
}
