terraform {
    backend "local" {
    }
}

module "service" {
    source = "../../modules/gcp/service"
    project_id = var.project_id
}

module "iam" {
    source = "../../modules/gcp/iam"
    project_id = var.project_id
    region = var.region
    depends_on = [module.service]
}
