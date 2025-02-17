terraform {
  backend "gcs" {
    bucket = "goboolean-450909-terraform-state"
    prefix = "core"
  }
}

module "istio_gateway" {
  source = "../../modules/infra/istio/gateway"
}

module "cert_manager_manifest" {
  source = "../../modules/infra/cert-manager/manifest"
  cloudflare_api_token = local.cloudflare_api_token
}
