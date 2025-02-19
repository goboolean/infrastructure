provider "google" {
  project = var.project_id
  region = var.region
}

data "google_secret_manager_secret_version" "vault_role_id" {
  secret = "vault_role_id"
}

data "google_secret_manager_secret_version" "vault_secret_id" {
  secret = "vault_secret_id"
}

provider "vault" {
  address = "https://vault.goboolean.io"
  auth_login {
    path = "auth/approle/login"
    parameters = {
      role_id   = data.google_secret_manager_secret_version.vault_role_id.secret_data
      secret_id = data.google_secret_manager_secret_version.vault_secret_id.secret_data
    }
  }
}
