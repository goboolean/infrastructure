resource "google_kms_key_ring" "vault_keyring" {
  name     = "vault-keyring"
  location = var.region
  project  = var.main_project_id

  depends_on = [google_project_service.services]
}

resource "google_kms_crypto_key" "vault_crypto_key" {
  name            = "vault-key"
  key_ring        = google_kms_key_ring.vault_keyring.id
  rotation_period = "7776000s" # 90d

  depends_on = [google_kms_key_ring.vault_keyring]
}
