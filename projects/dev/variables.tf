data "vault_kv_secret_v2" "gcp" {
  path = "kv-v2/data/infra/gcp"
}

data "vault_kv_secret_v2" "cloudflare" {
  path = "kv-v2/data/infra/cloudflare"
}

data "vault_kv_secret_v2" "argocd" {
  path = "kv-v2/data/infra/argocd"
}

variable "project_id" {
  description = "project id"
  type        = string
  default     = data.vault_kv_secret_v2.gcp.data["project_id"]
}

variable "region" {
  description = "region"
  type        = string
  default     = data.vault_kv_secret_v2.gcp.data["region"]
}

variable "zone" {
  description = "zone"
  type        = string
  default     = data.vault_kv_secret_v2.gcp.data["zone"]
}

variable "location" {
  description = "location"
  type        = string
  default     = data.vault_kv_secret_v2.gcp.data["location"]
}

variable "cloudflare_email" {
  description = "cloudflare email"
  type        = string
  default     = data.vault_kv_secret_v2.cloudflare.data["email"]
}

variable "cloudflare_api_token" {
  description = "cloudflare api token"
  type        = string
  default     = data.vault_kv_secret_v2.cloudflare.data["api_token"]
}

variable "cloudflare_zone_id" {
  description = "cloudflare zone id"
  type        = string
  default     = data.vault_kv_secret_v2.cloudflare.data["zone_id"]
}

variable "cloudflare_api_key" {
  description = "cloudflare api key"
  type        = string
  default     = data.vault_kv_secret_v2.cloudflare.data["api_key"]
}

variable "argocd_auth_token" {
  description = "argocd auth token"
  type        = string
  default     = data.vault_kv_secret_v2.argocd.data["auth_token"]
}

variable "argocd_password" {
  description = "argocd password"
  type        = string
  default     = data.vault_kv_secret_v2.argocd.data["password"]
}
