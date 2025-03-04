#Active Users
resource "github_team" "active_users" {
    name = "Active Users"
    description = "Active Users"
}

resource "github_team_members" "active_users" {
  team_id  = github_team.active_users.id

  members {
    username = "mulmuri"
    role     = "member"
  }

  members {
    username = "ikjeong"
    role     = "member"
  }

  members {
    username = "goboolean-io"
    role     = "member"
  }

  members {
    username = "dawit0905"
    role     = "member"
  }

  members {
    username = "lsjtop10"
    role     = "member"
  }
}

#Admin
resource "github_team" "admin" {
  name = "admin"
  description = "Admin team"
}

resource "github_team_members" "admin_members" {
  team_id  = github_team.admin.id

  members {
    username = "mulmuri"
    role     = "maintainer"
  }

  members {
    username = "ikjeong"
    role     = "maintainer"
  }

  members {
    username = "goboolean-io"
    role     = "maintainer"
  }
}



#DevOps
resource "github_team" "devops" {
  name        = "DevOps"
  description = "DevOps team"
}

resource "github_team_members" "devops_members" {
  team_id  = github_team.devops.id

  members {
    username = "mulmuri"
    role     = "maintainer"
  }

  members {
    username = "ikjeong"
    role     = "maintainer"
  }
}

data "github_repositories" "infra_repos" {
  query = "topic:devops org:goboolean"
}

resource "github_team_repository" "devops_access" {
  for_each = toset(data.github_repositories.infra_repos.names)

  team_id    = github_team.devops.id
  repository = each.value
  permission = "push"
}


#DE
resource "github_team" "de" {
  name = "DE"
  description = "Data Engineering"
}

resource "github_team_members" "de_members" {
  team_id  = github_team.de.id

  members {
    username = "mulmuri"
    role     = "maintainer"
  }

  members {
    username = "dawit0905"
    role     = "maintainer"
  }
}

data "github_repositories" "de_repos" {
  query = "topic:de org:goboolean"
}

resource "github_team_repository" "de_access" {
  for_each = toset(data.github_repositories.de_repos.names)

  team_id    = github_team.de.id
  repository = each.value
  permission = "push"
}


#Backend
resource "github_team" "backend" {
  name = "Backend"
  description = "Backend team"
}

resource "github_team_members" "backend_members" {
  team_id  = github_team.backend.id

  members {
    username = "mulmuri"
    role     = "maintainer"
  }

  members {
    username = "lsjtop10"
    role     = "maintainer"
  }
}

data "github_repositories" "backend_repos" {
  query = "topic:backend org:goboolean"
}

resource "github_team_repository" "backend_access" {
  for_each = toset(data.github_repositories.backend_repos.names)

  team_id    = github_team.backend.id
  repository = each.value
  permission = "push"
}
