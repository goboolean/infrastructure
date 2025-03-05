terraform {
  backend "gcs" {
    bucket = "goboolean-450909-tfstate"
    prefix = "452007/k8s/infra/configs"
  }

  required_providers {
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
}

provider "kubernetes" {
  host                   = local.gke_host
  token                  = local.gke_token
  cluster_ca_certificate = local.gke_cluster_ca_certificate
}

provider "google" {
  project = var.project_id
  region = var.region
}

ephemeral "google_service_account_jwt" "vault_jwt" {
  target_service_account = "atlantis@${var.project_id}.iam.gserviceaccount.com"

  payload = jsonencode({
    sub: "atlantis@${var.project_id}.iam.gserviceaccount.com",
    aud: "vault/terraform",
  })

  expires_in = 1800
}

provider "vault" {
  address = "https://vault.goboolean.io"
  
  auth_login {
    path = "auth/gcp/login"
    parameters = {
      jwt  = ephemeral.google_service_account_jwt.vault_jwt.jwt
      role = "terraform"
    }
  }
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

data "vault_kv_secret_v2" "harbor" {
  mount = "kv"
  name = "infra/harbor"
}

provider "harbor" {
  url = "https://registry.goboolean.io"
  username = data.vault_kv_secret_v2.harbor.data["username"]
  password = data.vault_kv_secret_v2.harbor.data["password"]
}
