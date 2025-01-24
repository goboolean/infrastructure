terraform {
    backend "local" {
    }
}

module "service" {
    source = "../../modules/gcp/service"
    project_id = var.project_id
}
/*
module "iam" {
    source = "../../modules/gcp/iam"
    project_id = var.project_id
    region = var.region
    depends_on = [module.service]
}
*/


/*
module "gke" {
    source = "../../modules/gcp/gke"
    project_id = var.project_id
    region = var.region
    zone = var.zone
}

module "harbor" {
    source = "../../modules/infra/harbor"
    depends_on = [module.gke]
}
*/
