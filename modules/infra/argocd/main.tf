resource "helm_release" "argocd" {
  name       = "argocd"
  chart      = "argo-cd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "7.7.21"

  values = [
    file("${path.module}/values.yaml")
  ]

  depends_on = [kubernetes_manifest.argocd_cmp_plugin]
}

resource "kubernetes_manifest" "argocd_cmp_plugin" {
  manifest = yamldecode(file("${path.module}/cmp-plugin.yaml"))
}

resource "kubernetes_manifest" "argocd_gateway" {
  manifest = yamldecode(file("${path.module}/gateway.yaml"))

  depends_on = [helm_release.argocd]
}

resource "kubernetes_secret" "argocd_vault_plugin_credentials" {
  metadata {
    name      = "argocd-vault-plugin-credentials"
    namespace = "argocd"
  }

  type = "Opaque"

  data = {
    VAULT_ADDR    = "http://vault.vault:8200"
    AVP_TYPE      = "vault"
    AVP_AUTH_TYPE = "k8s"
    AVP_K8S_ROLE  = "argocd"
  }

  depends_on = [helm_release.argocd]
}

data "kubernetes_secret" "argocd_initial_password" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = "argocd"
  }

  depends_on = [helm_release.argocd]
}
