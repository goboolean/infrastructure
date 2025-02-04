# Google Cloud Platform
variable "project_id" {
  description = "project id"
}
variable "region" {
  description = "region"
}
variable "zone" {
  description = "zone"
}
variable "location" {
  description = "location"
}

# Cloudflare
variable "cloudflare_email" {
  description = "cloudflare email"
}
variable "cloudflare_api_token" {
  description = "cloudflare api token"
}
variable "cloudflare_zone_id" {
  description = "cloudflare zone id"
}
variable "cloudflare_api_key" {
  description = "cloudflare api key"
}

/*
  The following infrastructure depends on Vault.
  Therefore, it should be separated into a distinct module
  and divided into stages.
*/
variable "vault_role_id" {
  description = "vault role id"
}
variable "vault_secret_id" {
  description = "vault secret id"
}
