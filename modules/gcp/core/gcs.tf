resource "google_storage_bucket" "terraform_state" {
  name          = "${var.main_project_id}-tfstate"
  location      = var.location
  project       = var.main_project_id

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true

  public_access_prevention = "enforced"
}
