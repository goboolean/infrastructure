terraform {
  backend "gcs" {
    bucket = "goboolean-450909-tfstate"
    prefix = "452007/k8s/vault/deployments"
  }
}

module "vault" {
  source = "../../../../modules/infra/vault"
  project_id = var.project_id
  region = var.region
  key_ring_name = local.vault_kms_keyring_name
  crypto_key_name = local.vault_kms_crypto_key_name
}
