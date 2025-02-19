resource "github_actions_organization_secret" "registry_username" {
  secret_name     = "REGISTRY_USERNAME"
  visibility      = "all"
  plaintext_value = var.registry_username
}

resource "github_actions_organization_secret" "registry_password" {
  secret_name     = "REGISTRY_PASSWORD"
  visibility      = "all"
  plaintext_value = var.registry_password
}
