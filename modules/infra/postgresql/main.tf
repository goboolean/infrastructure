resource "kubernetes_manifest" "postgresql-init-script" {
  manifest = file("${path.module}/postgresql-init-script.yaml")
}

locals {
  values_yaml = templatefile("${path.module}/values.yaml", {
    username = var.username
    password = var.password
  })
}

resource "helm_release" "postgresql" {
  name             = "postgresql"
  chart            = "postgresql"
  namespace        = "postgresql"
  repository       = "https://charts.bitnami.com/bitnami"
  version          = "16.4.5"
  
  values = [local.values_yaml]

  timeout = 600

  depends_on = [kubernetes_manifest.postgresql-init-script]
}
