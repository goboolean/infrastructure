resource "kubernetes_manifest" "postgresql-init-script" {
  manifest = yamldecode(file("${path.module}/postgresql-init-script.yaml"))
}

locals {
  values_yaml = templatefile("${path.module}/values.yaml", {
    username = var.postgresql_username
    password = var.postgresql_password
  })
}

resource "helm_release" "postgresql" {
  name             = "postgresql"
  chart            = "postgresql"
  namespace        = "postgresql"
  repository       = "oci://registry-1.docker.io/bitnamicharts"
  version          = "16.4.6"
  
  values = [local.values_yaml]

  timeout = 600

  depends_on = [kubernetes_manifest.postgresql-init-script]
}
