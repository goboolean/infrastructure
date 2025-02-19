resource "github_repository_webhook" "atlantis_webhook" {
  repository = "infrastructure"

  configuration {
    url          = "https://atlantis.goboolean.io/events"
    content_type = "json"
    insecure_ssl = false
    secret = var.atlantis_webhook_secret
  }

  active = true

  events = [
    "issue_comment",
    "pull_request",
    "pull_request_review",
    "push",
  ]
}
