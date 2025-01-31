data "kustomization_build" "argocd" {
  path = "${path.module}/base"
}

# first loop through resources in ids_prio[0]
resource "kustomization_resource" "p0" {
  for_each = data.kustomization_build.argocd.ids_prio[0]

  manifest = (
    contains(["_/Secret"], regex("(?P<group_kind>.*/.*)/.*/.*", each.value)["group_kind"])
    ? sensitive(data.kustomization_build.argocd.manifests[each.value])
    : data.kustomization_build.argocd.manifests[each.value]
  )
}

# then loop through resources in ids_prio[1]
# and set an explicit depends_on on kustomization_resource.p0
# wait 2 minutes for any deployment or daemonset to become ready
resource "kustomization_resource" "p1" {
  for_each = data.kustomization_build.argocd.ids_prio[1]

  manifest = (
    contains(["_/Secret"], regex("(?P<group_kind>.*/.*)/.*/.*", each.value)["group_kind"])
    ? sensitive(data.kustomization_build.argocd.manifests[each.value])
    : data.kustomization_build.argocd.manifests[each.value]
  )
  wait = true
  timeouts {
    create = "2m"
    update = "2m"
  }

  depends_on = [kustomization_resource.p0]
}

# finally, loop through resources in ids_prio[2]
# and set an explicit depends_on on kustomization_resource.p1
resource "kustomization_resource" "p2" {
  for_each = data.kustomization_build.argocd.ids_prio[2]

  manifest = (
    contains(["_/Secret"], regex("(?P<group_kind>.*/.*)/.*/.*", each.value)["group_kind"])
    ? sensitive(data.kustomization_build.argocd.manifests[each.value])
    : data.kustomization_build.argocd.manifests[each.value]
  )

  depends_on = [kustomization_resource.p1]
}

resource "kubernetes_manifest" "argocd_repo_server_role" {
  manifest = yamldecode(file("${path.module}/role/argocd-repo-server-rbac.yaml"))
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
}

resource "kubernetes_manifest" "argocd_vault_plugin_rolebinding" {
  manifest = yamldecode(file("${path.module}/role/argocd-vault-plugin-role-binding.yaml"))
}
