variable "project_id" {
  type        = string
}

variable "main_project_id" {
  type        = string
}

variable "region" {
  type        = string
}

output "access_key" {
  value = google_storage_hmac_key.airflow_hmac_key.access_id
}
output "secret_key" {
  value = google_storage_hmac_key.airflow_hmac_key.secret
  sensitive = true
}
