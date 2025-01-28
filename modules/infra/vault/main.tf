resource "helm_release" "vault" {
  name       = "vault"
  chart      = "vault"
  namespace  = "vault"
  repository = "https://helm.releases.hashicorp.com"
  version    = "0.28.1"

  values = [
    file("${path.module}/values.yaml")
  ]
}