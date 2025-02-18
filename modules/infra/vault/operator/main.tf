locals {
    values_yaml = templatefile("${path.module}/values.yaml", {
        vault_endpoint = "https://vault.goboolean.io"
        vault_role_id = var.vault_role_id
        vault_secret_id = var.vault_secret_id
    })
}

resource "helm_release" "vault_secrets_operator" {
  name       = "vault-secrets-operator"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault-secrets-operator"
  namespace  = "vault"

  values = [
    local.values_yaml
  ]
}
