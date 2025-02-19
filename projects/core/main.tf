terraform {
  backend "gcs" {
    bucket = "goboolean-450909-terraform-state"
    prefix = "core"
  }
}

module "istio_gateway" {
  source = "../../modules/infra/istio/gateway"
}

module "cert_manager_manifest" {
  source = "../../modules/infra/cert-manager/manifest"
  cloudflare_api_token = local.cloudflare_api_token
}

module "vault" {
  source = "../../modules/infra/vault"
  project_id = var.project_id
  region = var.region
  key_ring_name = local.vault_kms_keyring_name
  crypto_key_name = local.vault_kms_crypto_key_name
}
