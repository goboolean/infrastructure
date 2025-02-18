resource "vault_mount" "kv_v2" {
  path        = "kv"
  type        = "kv-v2"
  description = "KV Version 2 Secrets Engine"
}

resource "vault_policy" "argocd" {
  name   = "argocd"
  policy = <<EOT
path "kv-v2/data/*" {
  capabilities = ["read"]
}
EOT
}

resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "k8s_auth" {
  backend            = vault_auth_backend.kubernetes.path
  token_reviewer_jwt = var.token_reviewer_jwt
  kubernetes_host    = "${var.kubernetes_host}:443"
  kubernetes_ca_cert = var.kubernetes_ca_cert
}

resource "vault_kubernetes_auth_backend_role" "argocd" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "argocd"
  bound_service_account_names      = ["argocd-repo-server"]
  bound_service_account_namespaces = ["argocd"]
  token_policies                   = [vault_policy.argocd.name]
  token_ttl                        = "3600"
}
