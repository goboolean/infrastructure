resource "harbor_project" "fetch-system" {
  name                   = "fetch-system"
  public                 = true
  vulnerability_scanning = true
  depends_on = [helm_release.harbor]
}

resource "harbor_retention_policy" "fetch-system-retention" {
  scope    = harbor_project.fetch-system.id
  schedule = "Daily"

  rule {
    most_recently_pushed = 2 
    repo_matching        = "**"
  }
  depends_on = [harbor_project.fetch-system]
}

resource "harbor_garbage_collection" "gc-schedule" {
  schedule = "Daily"
  workers  = 1
  depends_on = [helm_release.harbor]
}
