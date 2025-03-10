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
    labels = {
      "istio-injection" = "enabled"
    }
  }
}

resource "kubernetes_namespace" "etcd" {
  metadata {
    name = "etcd"
    labels = {
      "istio-injection" = "enabled"
    }
  }
}

resource "kubernetes_namespace" "opentelemetry" {
  metadata {
    name = "opentelemetry"
    labels = {
      "istio-injection" = "enabled"
    }
  }
}

resource "kubernetes_namespace" "harbor" {
  metadata {
    name = "harbor"
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

resource "kubernetes_namespace" "postgresql" {
  metadata {
    name = "postgresql"
    labels = {
      "istio-injection" = "enabled"
    }
  }
}

resource "kubernetes_namespace" "influxdata" {
  metadata {
    name = "influxdata"
    labels = {
      "istio-injection" = "enabled"
    }
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_namespace" "airflow" {
  metadata {
    name = "airflow"
  }
}

resource "kubernetes_namespace" "dex" {
  metadata {
    name = "dex"
  }
}

resource "kubernetes_namespace" "atlantis" {
  metadata {
    name = "atlantis"
  }
}

resource "kubernetes_namespace" "kiali" {
  metadata {
    name = "kiali"
  }
}

resource "kubernetes_namespace" "open-webui" {
  metadata {
    name = "open-webui"
  }
}

resource "kubernetes_namespace" "redis" {
  metadata {
    name = "redis"
  }
}
