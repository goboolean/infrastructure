terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.84.0"
    }
  }
  required_version = ">= 0.14"
}

# cloudflare secrets
provider "google" {
  project = var.project_id
  region = var.region
}

data "google_secret_manager_secret_version" "cloudflare_api_token" {
  secret = "cloudflare_api_token"
}

locals {
  cloudflare_api_token = data.google_secret_manager_secret_version.cloudflare_api_token.secret_data
}

# gke secrets
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

  vault_kms_keyring_name     = data.terraform_remote_state.gcp.outputs.vault_kms_keyring_name
  vault_kms_crypto_key_name  = data.terraform_remote_state.gcp.outputs.vault_kms_crypto_key_name
}

# providers
provider "helm" {
  kubernetes {
    host                   = local.gke_host
    token                  = local.gke_token
    cluster_ca_certificate = local.gke_cluster_ca_certificate
  }
}

provider "kubernetes" {
  host                   = local.gke_host
  token                  = local.gke_token
  cluster_ca_certificate = local.gke_cluster_ca_certificate
}
