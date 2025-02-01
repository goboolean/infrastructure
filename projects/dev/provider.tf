terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.84.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.0.0-rc1"
    }

    acme = {
      source = "vancluever/acme"
      version = "2.29.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }

    argocd = {
      source = "argoproj-labs/argocd"
      version = "7.3.0"
    }
  }
  required_version = ">= 0.14"
}

provider "google" {
  project = var.project_id
  region = var.region
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "kubernetes" {
  host                   = module.gke.kubernetes_provider_config.host
  token                  = module.gke.kubernetes_provider_config.token
  cluster_ca_certificate = module.gke.kubernetes_provider_config.cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    host                   = module.gke.kubernetes_provider_config.host
    token                  = module.gke.kubernetes_provider_config.token
    cluster_ca_certificate = module.gke.kubernetes_provider_config.cluster_ca_certificate
  }
}

provider "acme" {
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

provider "kubectl" {
  host                   = module.gke.kubernetes_provider_config.host
  token                  = module.gke.kubernetes_provider_config.token
  cluster_ca_certificate = module.gke.kubernetes_provider_config.cluster_ca_certificate
  load_config_file       = false
}

provider "kustomization" {
  kubeconfig_path = "~/.kube/config"
}

provider "argocd" {
  server_addr = "argocd.goboolean.io:443"
  auth_token = var.argocd_auth_token
}
