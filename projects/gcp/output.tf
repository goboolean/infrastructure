output "vault_kms_keyring_name" {
  value = module.kms.vault_kms_keyring_name
  sensitive = true
}

output "vault_kms_crypto_key_name" {
  value = module.kms.vault_kms_crypto_key_name
  sensitive = true
}

output "kubernetes_provider_config" {
  value = module.gke.kubernetes_provider_config
  sensitive = true
}
