module "kustomize_argocd" {
  source  = "kbst.xyz/catalog/custom-manifests/kustomization"
  version = "0.3.0"

  configuration_base_key = "default"
  configuration = {
    default = {
      namespace = "argocd"

      resources = [
        "${path.module}/kustomization.yaml",
      ]
    }
  }
}

resource "kubernetes_manifest" "argocd_gateway" {
  manifest = yamldecode(file("${path.module}/gateway.yaml"))
  depends_on = [helm_release.argocd]
}