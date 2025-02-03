resource "argocd_application" "fetch-system-util" {
  metadata {
    name      = "fetch-system-util"
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
      path            = "fetch-system.util/kustomize/overlays/dev"
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
