resource "kubernetes_secret" "cloudflare_api_token" {
  metadata {
    name      = "cloudflare-api-token-secret"
    namespace = "cert-manager"
  }

  data = {
    "api-token" = var.cloudflare_api_token
  }
}

resource "kubectl_manifest" "cluster_issuer" {
  yaml_body = file("${path.module}/cluster-issuer.yaml")
  metadata {
    namespace = "cert-manager"
  }

  depends_on = [kubernetes_secret.cloudflare_api_token]
}

resource "kubectl_manifest" "wildcard_certificate" {
  yaml_body = file("${path.module}/certificate.yaml")
  metadata {
    namespace = "cert-manager"
  }

  depends_on = [kubectl_manifest.cluster_issuer]
}