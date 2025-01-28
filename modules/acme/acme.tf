resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = "darkblue31415@gmail.com"
}

resource "acme_certificate" "certificate" {
  account_key_pem           = acme_registration.reg.account_key_pem
  common_name               = "goboolean.io"
  subject_alternative_names = ["goboolean.io"]

  dns_challenge {
    provider = "cloudflare"
    config = {
      CF_API_EMAIL = var.cloudflare_email
      CF_API_KEY = var.cloudflare_api_key
      CF_DNS_API_TOKEN = var.cloudflare_api_token
      CF_ZONE_API_TOKEN = var.cloudflare_api_token
    }
  }
}
