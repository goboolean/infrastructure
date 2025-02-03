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
  It is not possible to deploy all infrastructure with a single main.tf.
  Therefore, the steps need to be divided,
  and the following variables can be injected starting from the second step,
  so they should be moved later.
*/
variable "vault_role_id" {
  description = "vault role id"
}

variable "vault_secret_id" {
  description = "vault secret id"
}
