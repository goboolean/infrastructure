output "vault_kms_keyring_name" {
  value = module.core.vault_kms_keyring_name
  sensitive = true
}

output "vault_kms_crypto_key_name" {
  value = module.core.vault_kms_crypto_key_name
  sensitive = true
}

output "cloudflare_api_token" {
  description = "Cloudflare API token"
  value       = local.cloudflare_api_token
  sensitive   = true
}

output "cloudflare_zone_id" {
  description = "Cloudflare zone ID"
  value       = local.cloudflare_zone_id
  sensitive   = true
}
