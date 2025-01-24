resource "google_project_service" "services" {
  for_each = toset([
    "serviceusage.googleapis.com",
    "compute.googleapis.com"
  ])
  
  project = var.project_id
  service = each.key
  
  disable_dependent_services = true
  disable_on_destroy = true
}