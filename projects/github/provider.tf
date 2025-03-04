provider "google" {
  project = var.project_id
  region = var.region
}

ephemeral "google_service_account_jwt" "vault_jwt" {
  target_service_account = "atlantis@${var.project_id}.iam.gserviceaccount.com"

  payload = jsonencode({
    sub: "atlantis@${var.project_id}.iam.gserviceaccount.com",
    aud: "vault/terraform",
  })

  expires_in = 1800
}

provider "vault" {
  address = "https://vault.goboolean.io"
  
  auth_login {
    path = "auth/gcp/login"
    parameters = {
      jwt  = ephemeral.google_service_account_jwt.vault_jwt.jwt
      role = "terraform"
    }
  }
}

provider "github" {
  owner = "goboolean"
  token = local.github_token
}
