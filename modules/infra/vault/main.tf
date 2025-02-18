resource "helm_release" "vault" {
  name       = "vault"
  chart      = "vault"
  namespace  = "vault"
  repository = "https://helm.releases.hashicorp.com"
  version    = "0.29.1"
  create_namespace = true

  values = [templatefile("${path.module}/values.yaml", {
    project_id = var.project_id
    region = var.region
    key_ring_name = var.key_ring_name
    crypto_key_name = var.crypto_key_name
  })]
}

resource "kubernetes_manifest" "vault_gateway" {
  manifest = yamldecode(file("${path.module}/gateway.yaml"))
  depends_on = [helm_release.vault]
}

resource "kubernetes_manifest" "vault_serviceaccount_token" {
  manifest = yamldecode(file("${path.module}/serviceaccount.yaml"))
  depends_on = [helm_release.vault]
}
