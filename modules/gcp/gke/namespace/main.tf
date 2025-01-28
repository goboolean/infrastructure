resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "kubernetes_namespace" "harbor" {
  metadata {
    name = "harbor"
    labels = {
      name = "harbor"
    }
  }
}

resource "kubernetes_namespace" "vault" {
  metadata {
    name = "vault"
  }
}