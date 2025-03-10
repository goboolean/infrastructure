locals {
  services = toset([
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "serviceusage.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "storage.googleapis.com",
    "secretmanager.googleapis.com",
    "cloudkms.googleapis.com",
  ])
}

resource "google_project_service" "services" {
  for_each = local.services
  
  project = var.project_id
  service = each.key
  
  disable_dependent_services = true
  disable_on_destroy = false
}
