terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.84.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
  }
  required_version = ">= 0.14"
}

provider "helm" {
  kubernetes {
    host                   = local.gke_host
    token                  = local.gke_token
    cluster_ca_certificate = local.gke_cluster_ca_certificate
  }
}

data "terraform_remote_state" "core" {
  backend = "gcs"

  config = {
    bucket = "goboolean-450909-tfstate"
    prefix = "450909/gcp/core"
  }
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
  vault_kms_keyring_name     = data.terraform_remote_state.core.outputs.vault_kms_keyring_name
  vault_kms_crypto_key_name  = data.terraform_remote_state.core.outputs.vault_kms_crypto_key_name

  gke_host                   = data.terraform_remote_state.gcp.outputs.kubernetes_provider_config.host
  gke_token                  = data.google_client_config.default.access_token
  gke_cluster_ca_certificate = data.terraform_remote_state.gcp.outputs.kubernetes_provider_config.cluster_ca_certificate
}

provider "kubectl" {
  host                   = local.gke_host
  token                  = local.gke_token
  cluster_ca_certificate = local.gke_cluster_ca_certificate
  load_config_file       = false
}

provider "kubernetes" {
  host                   = local.gke_host
  token                  = local.gke_token
  cluster_ca_certificate = local.gke_cluster_ca_certificate
}
