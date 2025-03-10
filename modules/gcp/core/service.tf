locals {
  services = toset([
    "secretmanager.googleapis.com",
    "cloudkms.googleapis.com"
  ])
}

resource "google_project_service" "services" {
  for_each = local.services
  
  project = var.main_project_id
  service = each.key
  
  disable_dependent_services = true
  disable_on_destroy = false
}
