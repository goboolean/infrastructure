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
  }
  required_version = ">= 0.14"
}

# cloudflare secrets
provider "google" {
  project = var.project_id
  region = var.region
}

data "google_secret_manager_secret_version" "cloudflare_email" {
  secret = "cloudflare_email"
}

data "google_secret_manager_secret_version" "cloudflare_api_token" {
  secret = "cloudflare_api_token"
}

data "google_secret_manager_secret_version" "cloudflare_zone_id" {
  secret = "cloudflare_zone_id"
}

data "google_secret_manager_secret_version" "cloudflare_api_key" {
  secret = "cloudflare_api_key"
}

locals {
  cloudflare_email     = data.google_secret_manager_secret_version.cloudflare_email.secret_data
  cloudflare_api_token = data.google_secret_manager_secret_version.cloudflare_api_token.secret_data
  cloudflare_zone_id   = data.google_secret_manager_secret_version.cloudflare_zone_id.secret_data
  cloudflare_api_key   = data.google_secret_manager_secret_version.cloudflare_api_key.secret_data
}

# gke secrets
data "terraform_remote_state" "gcp" {
  backend = "gcs"

  config = {
    bucket = "goboolean-450909-terraform-state"
    prefix = "gcp"
  }
}

locals {
  gke_host                   = data.terraform_remote_state.gcp.outputs.kubernetes_provider_config.host
  gke_token                  = data.terraform_remote_state.gcp.outputs.kubernetes_provider_config.token
  gke_cluster_ca_certificate = data.terraform_remote_state.gcp.outputs.kubernetes_provider_config.cluster_ca_certificate
}

# providers
provider "cloudflare" {
  api_token = local.cloudflare_api_token
}

provider "acme" {
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

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
