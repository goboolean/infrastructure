locals {
  kustomize_applications = {
    "fetch-system-streams"       = {path: "fetch-system.streams/kustomize/overlays/dev",       namespace: "fetch-system"},
    "fetch-system-worker"        = {path: "fetch-system.worker/kustomize/overlays/dev",        namespace: "fetch-system"},
    "fetch-system-util"          = {path: "fetch-system.util/kustomize/overlays/dev",          namespace: "fetch-system"},
    "fetch-system-polygon-proxy" = {path: "fetch-system.polygon-proxy/kustomize/overlays/dev", namespace: "fetch-system"}
  }
}

locals {
  helm_applications = {
    "fetch-system-telegraf" = {
      values_path: "fetch-system.telegraf/helm/dev/values.yaml",
      repository: "https://helm.influxdata.com/",
      chart: "telegraf",
      version: "1.8.55",
      namespace: "fetch-system"
    }
  }
}

resource "argocd_application" "kustomize_application" {
  for_each = local.kustomize_applications

  metadata {
    name      = each.key
    namespace = "argocd"
  }

  cascade = true
  wait    = false
  
  spec {
    project = "default"

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = each.value.namespace
    }

    source {
      repo_url        = "https://github.com/goboolean/manifests"
      path            = each.value.path
      target_revision = "main"
    }

    sync_policy {
      automated {
        prune       = true
        self_heal   = true
        allow_empty = true
      }

      sync_options = ["StatusForceHealth=true"]
    }
  }
}

resource "argocd_application" "helm_application" {
  for_each = local.helm_applications

  metadata {
    name      = each.key
    namespace = "argocd"
  }

  cascade = true
  wait    = false
  
  spec {
    project = "default"

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = each.value.namespace
    }

    source {
      repo_url        = each.value.repository
      chart           = each.value.chart
      target_revision = each.value.version
      
      helm {
        value_files = [ "https://raw.githubusercontent.com/goboolean/manifests/refs/heads/main/${each.value.values_path}"]
      }
    }

    sync_policy {
      automated {
        prune       = true
        self_heal   = true
        allow_empty = true
      }

      sync_options = ["StatusForceHealth=true"]
    }
  }
}
