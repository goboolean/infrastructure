module "dns" {
  source = "../../../../modules/cloudflare/dns"
  api_token = local.cloudflare_api_token
  zone_id = local.cloudflare_zone_id
  ip_address = local.istio_gateway_ip
}

module "cert_manager_issuer" {
  source = "../../../../modules/infra/cert-manager/issuer"
  cloudflare_api_token = local.cloudflare_api_token
}

module "istio_gateway" {
  source = "../../../../modules/infra/istio/gateway"
}

