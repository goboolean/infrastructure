resource "google_storage_bucket" "terraform_state" {
  name          = "${var.project_id}-tfstate"
  location      = var.location
  project       = var.project_id

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true

  public_access_prevention = "enforced"
}
