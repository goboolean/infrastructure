resource "google_project_iam_custom_role" "vault_kms_custom_role" {
  project     = var.main_project_id
  role_id     = "vaultKmsRole"
  title       = "Vault KMS Custom Role"
  description = "Custom role for Vault to use KMS for auto-unseal with minimal permissions"
  
  permissions = [
    "cloudkms.cryptoKeyVersions.useToEncrypt",
    "cloudkms.cryptoKeyVersions.useToDecrypt",
    "cloudkms.cryptoKeys.get",
  ]
}

resource "google_kms_crypto_key_iam_binding" "vault_kms_custom_binding" {
  crypto_key_id = "projects/${var.main_project_id}/locations/${var.region}/keyRings/${google_kms_key_ring.vault_keyring.name}/cryptoKeys/${google_kms_crypto_key.vault_crypto_key.name}"
  role          = google_project_iam_custom_role.vault_kms_custom_role.id

  members = [
    "serviceAccount:vault-sa@${var.project_id}.iam.gserviceaccount.com"
  ]
}
