terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.20.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "kubernetes" {
  host                   = module.gke.kubernetes_provider_config.host
  token                  = module.gke.kubernetes_provider_config.token
  cluster_ca_certificate = module.gke.kubernetes_provider_config.cluster_ca_certificate
}
