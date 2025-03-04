locals {
  argocd_password_hash = bcrypt(var.admin_password, 10)
  values_yaml = templatefile("${path.module}/values.yaml", {
    argocd_password_hash = local.argocd_password_hash
  })
}

resource "helm_release" "argocd" {
  name       = "argocd"
  chart      = "argo-cd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "7.7.21"

  values = [local.values_yaml]

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

