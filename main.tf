terraform {
    backend "local" {
        path = "/srv/atlantis/terraform.tfstate"
    }
}