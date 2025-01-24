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

module "gce" {
    source = "../../modules/gcp/gce"
    zone = var.zone
    service_account_email = module.iam.atlantis_service_account_email
    depends_on = [module.service]
}
