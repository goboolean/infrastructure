locals {
  values_yaml = templatefile("${path.module}/values.yaml", {
    harbor_url      = "https://registry.goboolean.io"
    harbor_password = var.harbor_password
  })
}

resource "helm_release" "harbor" {
  name       = "harbor"
  repository = "https://helm.goharbor.io"
  chart      = "harbor"
  namespace        = "harbor"
  version          = "1.15.1"

  values = [local.values_yaml]
}

resource "kubernetes_manifest" "harbor_gateway" {
  manifest = yamldecode(file("${path.module}/gateway.yaml"))
}
