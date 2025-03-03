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

# for vault
resource "google_service_account" "vault_sa" {
  project = var.project_id
  account_id   = "vault-sa"
  display_name = "Vault Service Account"
}

resource "google_service_account_iam_binding" "vault_workload_identity_binding" {
  service_account_id = google_service_account.vault_sa.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[vault/vault-sa]"
  ]

  depends_on = [google_service_account.vault_sa]
}

resource "google_project_iam_custom_role" "vault_service_account_role" {
  role_id   = "VaultServiceAccountRole"
  project   = var.project_id
  title     = "Vault Service Account Role"
  description = "Role for Vault to authenticate using GCP service accounts"
  permissions = [
    "iam.serviceAccounts.get",
    "iam.serviceAccountKeys.get"
  ]
}

resource "google_project_iam_member" "vault_service_account_role_binding" {
  project = var.project_id
  role    = "projects/${var.project_id}/roles/VaultServiceAccountRole"
  member  = "serviceAccount:${google_service_account.vault_sa.email}"
}

# ƒor loki
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

resource "google_service_account_iam_binding" "loki_gcs_workload_identity_binding" {
  service_account_id = google_service_account.loki_gcs_sa.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[monitoring/loki-sa]"
  ]

  depends_on = [google_service_account.loki_gcs_sa]
}

### for airflow
resource "google_service_account" "airflow_sa" {
  project = var.project_id
  account_id   = "airflow-sa"
  display_name = "Airflow Service Account"
  description  = "Service account for Airflow"
}

resource "google_storage_bucket_iam_member" "airflow_iam" {
  bucket  = "${var.project_id}-stock-data"
  role    = "roles/storage.objectUser"
  member  = "serviceAccount:${google_service_account.airflow_sa.email}"

  depends_on = [google_service_account.airflow_sa]
}

resource "google_storage_hmac_key" "airflow_hmac_key" {
  service_account_email = google_service_account.airflow_sa.email
}

### for load-tester
resource "google_service_account" "load_tester_sa" {
  project = var.project_id
  account_id   = "load-tester-sa"
  display_name = "Load Tester Service Account"
  description  = "Service account for Load Tester"
}

resource "google_project_iam_member" "load_tester_storage" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.load_tester_sa.email}"
}

resource "google_storage_bucket_iam_member" "load_tester_role" {
  bucket  = "${var.project_id}-load-test"
  role    = "roles/storage.objectUser"
  member  = "serviceAccount:${google_service_account.load_tester_sa.email}"

  depends_on = [google_service_account.load_tester_sa]
}

resource "google_service_account_iam_binding" "load_tester_workload_identity_binding" {
  service_account_id = google_service_account.load_tester_sa.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[fetch-system/load-tester-sa]"
  ]

  depends_on = [google_service_account.load_tester_sa]
}

### for atlantis
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

resource "google_service_account_iam_binding" "workload_identity_binding" {
  service_account_id = google_service_account.atlantis.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[atlantis/atlantis]"
  ]
}

resource "google_service_account_iam_binding" "service_account_token_creator" {
  service_account_id = google_service_account.atlantis.name
  role               = "roles/iam.serviceAccountTokenCreator"
  members            = [
    "serviceAccount:${google_service_account.atlantis.email}",
    "user:jipark7937@gmail.com"
  ]
}
