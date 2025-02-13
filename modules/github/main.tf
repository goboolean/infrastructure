variable "repositories" {
    default = [
        "infrastructure",
        "manifests",
        "airflow-pipeline-factory",
        "fetch-system.worker",
        "fetch-system.util",
        "core-system.worker",
        "hts-connector",
        ".github",
        "GoCppLinkingLibrary",
        "common",
        "buycycle"
    ]
}

variable "archived_repositories" {
    default = [
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
    for_each = toset(var.repositories)

    name = each.value
    description = ""

    visibility = "public"
    has_issues = true

    delete_branch_on_merge = true
    allow_merge_commit = true
}

resource "github_branch_protection" "main_branch_protection" {
  for_each = toset(var.repositories)

  repository_id = github_repository.repository[each.value].node_id
  
  pattern = "main"
  
  required_pull_request_reviews {
    required_approving_review_count = 1
    dismiss_stale_reviews           = false
    require_code_owner_reviews      = false
    dismissal_restrictions          = []
  }

  required_status_checks {
    strict   = true
    contexts = []
  }

  enforce_admins = true  
  allows_deletions = false
  allows_force_pushes = false
}

resource "github_repository" "archived" {
    for_each = { for repo in var.archived_repositories : repo.name => repo }

    name = each.value.name
    description = ""

    visibility = each.value.visibility
    archived = true
}

