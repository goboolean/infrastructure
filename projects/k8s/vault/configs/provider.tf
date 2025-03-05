terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.23.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "4.6.0"
    }
  }
  required_version = ">= 0.14"
}

data "terraform_remote_state" "gcp" {
  backend = "gcs"

  config = {
    bucket = "goboolean-450909-tfstate"
    prefix = "452007/gcp"
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

data "kubernetes_secret" "vault_sa_token" {
  metadata {
    name      = "vault-sa-token"
    namespace = "vault"
  }
}

locals {
  token_reviewer_jwt = data.kubernetes_secret.vault_sa_token.data["token"]
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
