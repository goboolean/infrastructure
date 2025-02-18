resource "cloudflare_dns_record" "istio-gateway" {
  zone_id = var.zone_id
  content = var.ip_address
  name = "*.goboolean.io"
  proxied = false
  ttl = 1
  type = "A"
}
