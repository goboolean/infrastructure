#module "kustomize_argocd" {
#  source  = "kbst.xyz/catalog/custom-manifests/kustomization"
#  version = "0.3.0"
#
#  configuration_base_key = "default"
#  configuration = {
#    default = {
#      namespace = "argocd"
#
#      resources = [
#        "${path.module}/kustomization.yaml",
#      ]
#    }
#  }
#}
#
resource "kubernetes_manifest" "argocd_gateway" {
  manifest = yamldecode(file("${path.module}/gateway.yaml"))
}

resource "kubernetes_manifest" "argocd_repo_server_role" {
  manifest = yamldecode(file("${path.module}/argocd-repo-server-rbac.yaml"))
}

resource "kubernetes_manifest" "argocd_vault_plugin_role" {
  manifest = yamldecode(file("${path.module}/argocd-vault-plugin-role.yaml"))
}

resource "kubernetes_manifest" "argocd_repo_server_rolebinding" {
  manifest = yamldecode(file("${path.module}/argocd-vault-plugin-role-binding.yaml"))
}

