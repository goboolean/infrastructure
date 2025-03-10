locals {
    repositories = [
        {name = "infrastructure",           tags = ["devops"]},
        {name = "manifests",                tags = ["devops"]},
        {name = "airflow-pipeline-factory", tags = ["de"]},
        {name = "fetch-system.worker",      tags = ["backend"]},
        {name = "fetch-system.util",        tags = ["backend"]},
        {name = "core-system.worker",       tags = ["backend"]},
        {name = "hts-connector",            tags = ["backend"]},
        {name = ".github",                  tags = []},
        {name = "GoCppLinkingLibrary",      tags = ["ml"]},
        {name = "common",                   tags = []},
        {name = "airflow-dags",             tags = ["de"]}
    ]

    archived_repositories = [
        {name = "manager-cli",         visibility = "public"},
        {name = "schema-registry",     visibility = "private"},
        {name = "command-server",      visibility = "private"},
        {name = "fetch-system.master", visibility = "public" },
        {name = "core-system.command", visibility = "private"},
        {name = "core-system.join",    visibility = "private"},
        {name = "model-server",        visibility = "private"},
        {name = "ops",                 visibility = "private"},
        {name = "client",              visibility = "private"},
        {name = "identity-server",     visibility = "private"},
        {name = "fetch-server.v1",     visibility = "private"}
    ]
}


resource "github_repository" "repository" {
  for_each = { for repo in local.repositories : repo.name => repo }

  name = each.value.name
  description = ""

  visibility = "public"
  has_issues = true
  auto_init   = true

  delete_branch_on_merge = true
  allow_merge_commit = true
}

resource "github_repository_topics" "repository_topic" {
  for_each = { for repo in local.repositories : repo.name => repo }

  repository = each.value.name
  topics = each.value.tags

  depends_on = [github_repository.repository]
}

resource "github_branch_protection_v3" "main_branch_protection" {
  for_each = { for repo in local.repositories : repo.name => repo }

  repository = each.value.name
  branch = "main"
  enforce_admins = true  
  
  required_pull_request_reviews {
    required_approving_review_count = 1
    dismiss_stale_reviews           = false
    require_code_owner_reviews      = false
    bypass_pull_request_allowances {
      users = ["goboolean-io", "mulmuri", "ikjeong"]
      teams = ["goboolean/admin"]
    }
  }

  required_status_checks {
    strict   = true
  }

  depends_on = [github_repository.repository]
}

resource "github_repository" "archived" {
  for_each = { for repo in local.archived_repositories : repo.name => repo }

  name = each.value.name
  description = ""

  visibility = each.value.visibility
  archived = true
}
