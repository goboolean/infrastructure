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
        "buycycle",
        "core-system."
    ]
}

variable "archived_repositories" {
    default = [{
        name = "manager-cli",
        visibility = "private",
        archived = false,
    },
    {
        name = "schema-registry",
        visibility = "private",
        archived = false,
    },
    {
        name = "command-server",
        visibility = "private",
        archived = false,
    }]
}


resource "github_repository" "airflow" {
    for_each = var.repositories
    name = each.value

    visibility = "public"
    private = false
}
