terraform {
  backend "gcs" {
    bucket = "goboolean-450909-terraform-state"
    prefix = "domain"
  }
}

module "istio" {
  source = "../../modules/infra/istio"
}

module "dns" {
  source = "../../modules/cloudflare/dns"
  api_token = local.cloudflare_api_token
  zone_id = local.cloudflare_zone_id
  ip_address = module.istio.istio_gateway_ip

  depends_on = [module.istio]
}

module "acme" {
  source = "../../modules/cloudflare/acme"

  cloudflare_email = local.cloudflare_email
  cloudflare_api_token = local.cloudflare_api_token
  cloudflare_zone_id = local.cloudflare_zone_id
  cloudflare_api_key = local.cloudflare_api_key
}

module "cert_manager" {
  source = "../../modules/infra/cert-manager"
}
