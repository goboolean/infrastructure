terraform {
  backend "gcs" {
    bucket = "goboolean-450909-terraform-state"
    prefix = "gcp"
  }
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

module "gke" {
  source = "../../modules/gcp/gke"
  region = var.region
  project_id = var.project_id
  zone = var.zone

  depends_on = [module.service]
}

module "iam" {
  source = "../../modules/gcp/iam"
  project_id = var.project_id
  region = var.region

  depends_on = [module.gke, module.gcs]
}

module "storageclass" {
  source = "../../modules/gcp/gke/storageclass"
  depends_on = [module.gke]
}

resource "google_project_service" "secretmanager_api" {
  service = "secretmanager.googleapis.com"
  project = var.project_id
  disable_on_destroy = false
}
