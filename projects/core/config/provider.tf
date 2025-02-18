terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.84.0"
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

data "google_secret_manager_secret_version" "vault_role_id" {
  secret = "vault_role_id"
}

data "google_secret_manager_secret_version" "vault_secret_id" {
  secret = "vault_secret_id"
}

locals {
  vault_role_id   = data.google_secret_manager_secret_version.vault_role_id.secret_data
  vault_secret_id = data.google_secret_manager_secret_version.vault_secret_id.secret_data
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
