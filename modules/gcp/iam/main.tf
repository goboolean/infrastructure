resource "google_service_account" "atlantis" {
  account_id   = "atlantis"
  display_name = "Service Account for Atlantis"
  project      = var.project_id
}

resource "google_project_iam_member" "gke_admin" {
  project = var.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.atlantis.email}"
}

resource "google_project_iam_member" "compute_network_admin" {
  project = var.project_id
  role    = "roles/compute.networkAdmin"
  member  = "serviceAccount:${google_service_account.atlantis.email}"
}

resource "google_project_iam_member" "service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.atlantis.email}"
}
