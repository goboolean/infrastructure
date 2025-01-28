resource "cloudflare_dns_record" "atlantis" {
  zone_id = var.zone_id
  content = var.ip_address
  name = "atlantis.goboolean.io"
  proxied = true
  ttl = 1
  type = "A"
}

resource "cloudflare_certificate_pack" "example_certificate_pack" {
  zone_id = var.zone_id
  certificate_authority = "lets_encrypt"
  hosts = ["*.goboolean.io"]
  type = "advanced"
  validation_method = "txt"
  validity_days = 14
  cloudflare_branding = false
}
