resource "cloudflare_dns_record" "atlantis" {
  zone_id = var.zone_id
  content = var.ip_address
  name = "atlantis.goboolean.io"
  proxied = true
  ttl = 1
  type = "A"
}
