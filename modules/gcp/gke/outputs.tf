output "region" {
  value       = var.region
  description = "GCloud Region"
}

output "project_id" {
  value       = var.project_id
  description = "GCloud Project ID"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {
  value       = google_container_cluster.primary.endpoint
  description = "GKE Cluster Host"
}

output "cluster_ca_certificate" {
  value       = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  description = "GKE Cluster CA Certificate"
}

output "token" {
  value       = data.google_client_config.default.access_token
  description = "GKE Access Token"
  sensitive   = true
}

output "kubernetes_provider_config" {
  value = {
    host                   = google_container_cluster.primary.endpoint
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  }
}
