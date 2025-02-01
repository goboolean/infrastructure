terraform {
  required_providers {
    kustomization = {
      source = "kbst/kustomization"
      version = "0.9.6"
    }

    argocd = {
      source = "argoproj-labs/argocd"
      version = "7.3.0"
    }
  }
}
