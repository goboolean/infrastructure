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

    delete_branch_on_merge = true
    allow_merge_commit = true
}

resource "github_repository" "archived" {
    for_each = { for repo in var.archived_repositories : repo.name => repo }

    name = each.value.name
    description = ""

    visibility = each.value.visibility
    archived = true
}
