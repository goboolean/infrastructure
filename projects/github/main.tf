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

data "vault_kv_secret_v2" "harbor" {
  mount = "kv"
  name = "infra/harbor"
}

locals {
  github_token = data.vault_kv_secret_v2.github.data["admin_token"]
  atlantis_webhook_secret = data.vault_kv_secret_v2.github.data["atlantis_webhook_secret"]

  harbor_username = data.vault_kv_secret_v2.harbor.data["username"]
  harbor_password = data.vault_kv_secret_v2.harbor.data["password"]
}

module "repository" {
  source = "../../modules/github/repository"
}

module "webhook" {
  source = "../../modules/github/webhook"
  atlantis_webhook_secret = local.atlantis_webhook_secret
}

module "github_secret" {
  source = "../../modules/github/github_secret"
  registry_username = local.harbor_username
  registry_password = local.harbor_password
}

module "team" {
  source = "../../modules/github/team"
  depends_on = [module.repository]
}
