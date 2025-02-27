output "kubernetes_provider_config" {
  value = module.gke.kubernetes_provider_config
  sensitive = true
}

output "airflow_hmac_access_key" {
  description = "HMAC access key for Airflow service account"
  value       = module.iam.access_key
}

output "airflow_hmac_secret_key" {
  description = "HMAC secret key for Airflow service account"
  value       = module.iam.secret_key
  sensitive   = true
}
