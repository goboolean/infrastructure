terraform {
    backend "local" {
        path = "terraform.tfstate"
    }
    #backend "gcs" {
    #    bucket = "terraform-state"
    #    key = "gcp/terraform.tfstate"
    #}
}

module "service" {
    source = "../../modules/gcp/service"
    project_id = var.project_id
}

module "gcs" {
    source = "../../modules/gcp/gcs"
    project_id = var.project_id
    location = var.location

    depends_on = [module.service]
}

module "iam" {
    source = "../../modules/gcp/iam"
    project_id = var.project_id
    region = var.region

    depends_on = [module.service]
}
/*
module "gke" {
    source = "../../modules/gcp/gke"
    region = var.region
    project_id = var.project_id
    zone = var.zone

    depends_on = [module.service]
}
*/