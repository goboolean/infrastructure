/*
resource "kubernetes_secret" "cloudflare_api_token" {
  metadata {
    name      = "cloudflare-api-token-secret"
    namespace = "cert-manager"
  }

  data = {
    "api-token" = var.cloudflare_api_token
  }
}

resource "kubernetes_manifest" "cluster_issuer" {
  manifest = yamldecode(file("${path.module}/cluster-issuer.yaml"))

  depends_on = [kubernetes_secret.cloudflare_api_token]
}

resource "kubernetes_manifest" "wildcard_certificate" {
  manifest = yamldecode(file("${path.module}/certificate.yaml"))

  depends_on = [kubernetes_manifest.cluster_issuer]
}
*/