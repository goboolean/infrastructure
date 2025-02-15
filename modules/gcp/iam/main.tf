/*
resource "google_service_account" "atlantis" {
  account_id   = "atlantis"
  display_name = "Service Account for Atlantis"
  project      = var.project_id
}

resource "google_project_iam_member" "owner" {
  project = var.project_id
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.atlantis.email}"
}

resource "google_project_iam_member" "iam_admin" {
  project = var.project_id
  role    = "roles/resourcemanager.projectIamAdmin"
  member  = "serviceAccount:${google_service_account.atlantis.email}"
}

resource "google_project_iam_member" "service_account_admin" {
  project = var.project_id
  role    = "roles/iam.serviceAccountAdmin"
  member  = "serviceAccount:${google_service_account.atlantis.email}"
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

resource "google_project_iam_member" "compute_instance_admin" {
  project = var.project_id
  role    = "roles/compute.instanceAdmin.v1"
  member  = "serviceAccount:${google_service_account.atlantis.email}"
}


resource "google_project_iam_member" "service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.atlantis.email}"
}

resource "google_project_iam_member" "storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.atlantis.email}"
}

resource "google_storage_bucket_iam_member" "terraform_state_access" {
  bucket = "terraform-state"
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.atlantis.email}"
}
*/

# For loki
resource "google_service_account" "loki_gcs_sa" {
  project = var.project_id
  account_id   = "loki-gcs-sa"
  display_name = "Loki GCS Service Account"
  description  = "Service account for Loki to access GCS"
}

resource "google_storage_bucket_iam_member" "loki_gcs_role" {
  bucket  = "${var.project_id}-loki"
  role    = "roles/storage.objectUser"
  member  = "serviceAccount:${google_service_account.loki_gcs_sa.email}"

  depends_on = [google_service_account.loki_gcs_sa]
}

resource "google_service_account_iam_binding" "workload_identity_binding" {
  service_account_id = google_service_account.loki_gcs_sa.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[monitoring/loki-sa]"
  ]

  depends_on = [google_service_account.loki_gcs_sa]
}
