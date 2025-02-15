resource "google_storage_bucket" "terraform_state" {
  name          = "${var.project_id}-terraform-state"
  location      = var.location
  project       = var.project_id

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true

  public_access_prevention = "enforced"
}

resource "google_storage_bucket" "loki" {
  name          = "${var.project_id}-loki"
  location      = var.location
  project       = var.project_id

  uniform_bucket_level_access = true

  public_access_prevention = "enforced"
}

resource "google_storage_bucket" "stock_data" {
  name          = "${var.project_id}-stock-data"
  location      = var.location
  project       = var.project_id

  versioning {
    enabled = false
  }

  uniform_bucket_level_access = true

  public_access_prevention = "enforced"
}
