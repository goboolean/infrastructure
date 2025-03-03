provider "google" {
  project = var.main_project_id
  region = var.region
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

data "google_secret_manager_secret_version" "cloudflare_email" {
  secret = "cloudflare_email"
}

data "google_secret_manager_secret_version" "cloudflare_api_token" {
  secret = "cloudflare_api_token"
}

data "google_secret_manager_secret_version" "cloudflare_zone_id" {
  secret = "cloudflare_zone_id"
}

data "google_secret_manager_secret_version" "cloudflare_api_key" {
  secret = "cloudflare_api_key"
}

locals {
  cloudflare_email     = data.google_secret_manager_secret_version.cloudflare_email.secret_data
  cloudflare_api_token = data.google_secret_manager_secret_version.cloudflare_api_token.secret_data
  cloudflare_zone_id   = data.google_secret_manager_secret_version.cloudflare_zone_id.secret_data
  cloudflare_api_key   = data.google_secret_manager_secret_version.cloudflare_api_key.secret_data
}
