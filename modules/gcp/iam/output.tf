/*
output "atlantis_service_account_email" {
  value       = google_service_account.atlantis.email
}
*/

output "airflow_bucket_access_key" {
  value     = google_storage_hmac_key.airflow_hmac_key.access_id
  sensitive = true
}

output "airflow_bucket_secret_key" {
  value     = google_storage_hmac_key.airflow_hmac_key.secret
  sensitive = true
}