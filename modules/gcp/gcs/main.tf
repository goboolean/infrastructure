resource "google_storage_bucket" "terraform_state" {
  name          = "goboolean-terraform-state"
  location      = var.location
  project       = var.project_id

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true

  public_access_prevention = "enforced"
}

resource "google_storage_bucket" "loki" {
  name          = "goboolean-loki"
  location      = var.location
  project       = var.project_id

  versioning {
    enabled = false
  }

  uniform_bucket_level_access = true

  public_access_prevention = "enforced"
}
