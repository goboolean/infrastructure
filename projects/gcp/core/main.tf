terraform {
  backend "gcs" {
    bucket = "goboolean-450909-tfstate"
    prefix = "450909/gcp/core"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.20.0"
    }

    acme = {
      source = "vancluever/acme"
      version = "2.29.0"
    }
  }
}

module "core" {
  source = "../../../modules/gcp/core"
  project_id = var.project_id
  location = var.location
  region = var.region
}

module "acme" {
  source = "../../../modules/cloudflare/acme"

  cloudflare_email = local.cloudflare_email
  cloudflare_api_token = local.cloudflare_api_token
  cloudflare_zone_id = local.cloudflare_zone_id
  cloudflare_api_key = local.cloudflare_api_key
}
