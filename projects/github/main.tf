terraform {
  backend "gcs" {
    bucket = "goboolean-450909-terraform-state"
    prefix = "github"
  }
}

data "vault_kv_secret_v2" "github" {
  mount = "kv"
  name = "github"
}

locals {
  github_token = data.vault_kv_secret_v2.github.data["admin_token"]
  atlantis_webhook_secret = data.vault_kv_secret_v2.github.data["atlantis_webhook_secret"]
}

module "github" {
  source = "../../modules/github"
  atlantis_webhook_secret = local.atlantis_webhook_secret
}

provider "github" {
  owner = "goboolean"
  token = local.github_token
}



