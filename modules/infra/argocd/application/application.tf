resource "argocd_application" "fetch-system-streams" {
  metadata {
    name      = "fetch-system-streams"
    namespace = "argocd"
  }

  cascade = true
  wait    = true

  spec {
    project = "default"

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "fetch-system"
    }

    source {
      repo_url        = "https://github.com/goboolean/manifests"
      path            = "fetch-system.streams/kustomize/overlays/dev"
      target_revision = "main"
    }

    sync_policy {
      automated {
        prune       = true
        self_heal   = true
        allow_empty = true
      }
    }
  }
}

/*
resource "argocd_application" "fetch-system-worker" {
  metadata {
    name      = "fetch-system-worker"
    namespace = "argocd"
  }

  cascade = true
  wait    = true

  spec {
    project = "default"

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "fetch-system"
    }

    source {
      repo_url        = "https://github.com/goboolean/manifests"
      path            = "fetch-system.worker/kustomize/overlays/dev"
      target_revision = "main"
    }

    sync_policy {
      automated {
        prune       = true
        self_heal   = true
        allow_empty = true
      }
    }
  }
}
*/
