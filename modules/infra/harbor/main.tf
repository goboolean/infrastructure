locals {
  values_yaml = templatefile("${path.module}/values.yaml", {
    harbor_password = var.harbor_password
  })
}


resource "helm_release" "harbor" {
  name       = "harbor"
  repository = "https://helm.goharbor.io"
  chart      = "harbor"
  namespace        = "harbor"
  create_namespace = true
  version          = "1.16.2"

  values = [local.values_yaml]
}

resource "kubernetes_manifest" "harbor_gateway" {
  manifest = yamldecode(file("${path.module}/gateway.yaml"))
}
