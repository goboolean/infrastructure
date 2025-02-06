terraform {
  required_providers {
    harbor = {
      source  = "goharbor/harbor"
      version = "3.10.19"
    }
  }
}

provider "harbor" {
  url = var.harbor_url
  username = var.harbor_username
  password = var.harbor_password
}
