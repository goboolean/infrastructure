resource "google_service_account" "vault_kms_sa" {
  project = var.project_id
  account_id   = "vault-kms-sa"
  display_name = "Vault KMS Service Account"
}

resource "google_project_iam_custom_role" "vault_kms_custom_role" {
  role_id     = "vaultKmsRole"
  title       = "Vault KMS Custom Role"
  description = "Custom role for Vault to use KMS for auto-unseal with minimal permissions"
  project     = var.project_id

  permissions = [
    "cloudkms.cryptoKeyVersions.useToEncrypt",
    "cloudkms.cryptoKeyVersions.useToDecrypt",
    "cloudkms.cryptoKeys.get",
  ]
}
