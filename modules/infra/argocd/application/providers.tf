terraform {
  required_providers {
    argocd = {
      source = "argoproj-labs/argocd"
      version = "7.3.0"
    }
  }
}

provider "argocd" {
  server_addr = "argocd.goboolean.io:443"
  username = var.username
  password = var.password
}
