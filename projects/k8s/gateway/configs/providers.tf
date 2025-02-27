terraform {
  backend "gcs" {
    bucket = "goboolean-450909-tfstate"
    prefix = "452007/k8s/gateway/configs"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.84.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.1.0"
    }
  }
} 

data "terraform_remote_state" "gateway" {
  backend = "gcs"

  config = {
    bucket = "goboolean-450909-tfstate"
    prefix = "452007/k8s/gateway/deployments"
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
  istio_gateway_ip = data.terraform_remote_state.gateway.outputs.istio_gateway_ip

  cloudflare_api_token = data.terraform_remote_state.core.outputs.cloudflare_api_token
  cloudflare_zone_id   = data.terraform_remote_state.core.outputs.cloudflare_zone_id

  gke_host                   = data.terraform_remote_state.gcp.outputs.kubernetes_provider_config.host
  gke_token                  = data.google_client_config.default.access_token
  gke_cluster_ca_certificate = data.terraform_remote_state.gcp.outputs.kubernetes_provider_config.cluster_ca_certificate
}


provider "kubernetes" {
  host                   = local.gke_host
  token                  = local.gke_token
  cluster_ca_certificate = local.gke_cluster_ca_certificate
}

provider "kubectl" {
  host                   = local.gke_host
  token                  = local.gke_token
  cluster_ca_certificate = local.gke_cluster_ca_certificate
  load_config_file       = false
}

provider "cloudflare" {
  api_token = local.cloudflare_api_token
}
