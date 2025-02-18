resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  namespace  = "cert-manager"
  chart      = "cert-manager"
  repository = "https://charts.jetstack.io"
  version    = "v1.16.3"

  set {
    name  = "crds.enabled"
    value = "true"
  }

  set {
    name  = "webhook.timeoutSeconds"
    value = 10
  }
}
