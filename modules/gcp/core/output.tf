output "vault_kms_keyring_name" {
  value = google_kms_key_ring.vault_keyring.name
  sensitive = true
}

output "vault_kms_crypto_key_name" {
  value = google_kms_crypto_key.vault_crypto_key.name
  sensitive = true
}

output "vault_kms_crypto_key_id" {
  value = google_kms_crypto_key.vault_crypto_key.id
  sensitive = true
}

