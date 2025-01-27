terraform {
    backend "gcs" {
        bucket = "goboolean-terraform-state"
        prefix = "dev"
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

module "cloudflare" {
    source = "../../modules/cloudflare"
    api_token = var.cloudflare_api_token
    zone_id = var.cloudflare_zone_id
    ip_address = module.gce.ip_address
}

module "gcs" {
    source = "../../modules/gcp/gcs"
    project_id = var.project_id
    location = var.location
    depends_on = [module.service]
}

module "gke" {
    source = "../../modules/gcp/gke"
    project_id = var.project_id
    zone = var.zone
    depends_on = [module.service]
}