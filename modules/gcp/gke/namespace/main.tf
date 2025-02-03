resource "kubernetes_namespace" "istio-system" {
  metadata {
    name = "istio-system"
  }
}

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "kubernetes_namespace" "vault" {
  metadata {
    name = "vault"
  }
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_namespace" "kafka" {
  metadata {
    name = "kafka"
  }
}

resource "kubernetes_namespace" "etcd" {
  metadata {
    name = "etcd"
  }
}

resource "kubernetes_namespace" "opentelemetry" {
  metadata {
    name = "opentelemetry"
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

resource "kubernetes_namespace" "fetch-system" {
  metadata {
    name = "fetch-system"
    labels = {
      "istio-injection" = "enabled"
    }
  }
}
