locals {
  values_yaml = templatefile("${path.module}/values.yaml", {
    atlantis_url = "https://atlantis.goboolean.io"
    project_id = var.project_id
    github_token = var.github_token
    github_username = var.github_username
    webhook_secret = var.webhook_secret
    username = "username"
    password = "password"
  })
}

resource "helm_release" "atlantis" {
  name       = "atlantis"
  repository = "https://runatlantis.github.io/helm-charts"
  chart      = "atlantis"
  version    = "4.4.0"
  namespace  = "atlantis"

  values = [local.values_yaml]

  timeout = 120
}

resource "kubernetes_manifest" "atlantis_gateway" {
  manifest = yamldecode(file("${path.module}/gateway.yaml"))
}
