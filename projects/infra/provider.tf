terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "4.6.0"
    }

    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.3.0"
    }

    harbor = {
      source  = "goharbor/harbor"
      version = "3.10.19"
    }
  }
  required_version = ">= 0.14"
}

data "terraform_remote_state" "gcp" {
  backend = "gcs"

  config = {
    bucket = "goboolean-450909-terraform-state"
    prefix = "gcp"
  }
}

data "google_client_config" "default" {}

locals {
  gke_host                   = data.terraform_remote_state.gcp.outputs.kubernetes_provider_config.host
  gke_token                  = data.google_client_config.default.access_token
  gke_cluster_ca_certificate = data.terraform_remote_state.gcp.outputs.kubernetes_provider_config.cluster_ca_certificate

  vault_role_id = data.google_secret_manager_secret_version.vault_role_id.secret_data
  vault_secret_id = data.google_secret_manager_secret_version.vault_secret_id.secret_data
}

provider "google" {
  project = var.project_id
  region = var.region
}

data "google_secret_manager_secret_version" "vault_role_id" {
  secret = "vault_role_id"
}

data "google_secret_manager_secret_version" "vault_secret_id" {
  secret = "vault_secret_id"
}

provider "vault" {
  address = "https://vault.goboolean.io"
  auth_login {
    path = "auth/approle/login"
    parameters = {
      role_id   = local.vault_role_id
      secret_id = local.vault_secret_id
    }
  }
}

provider "kubernetes" {
  host                   = local.gke_host
  token                  = local.gke_token
  cluster_ca_certificate = local.gke_cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    host                   = local.gke_host
    token                  = local.gke_token
    cluster_ca_certificate = local.gke_cluster_ca_certificate
  }
}

provider "kubectl" {
  host                   = local.gke_host
  token                  = local.gke_token
  cluster_ca_certificate = local.gke_cluster_ca_certificate
  load_config_file       = false
}

data "vault_kv_secret_v2" "argocd" {
  mount = "kv"
  name = "infra/argocd"
}

provider "argocd" {
  server_addr = "argocd.goboolean.io:443"
  username = data.vault_kv_secret_v2.argocd.data["username"]
  password = data.vault_kv_secret_v2.argocd.data["password"]
}

provider "harbor" {
  url = "https://registry.goboolean.io"
  username = data.vault_kv_secret_v2.harbor.data["username"]
  password = data.vault_kv_secret_v2.harbor.data["password"]
}
