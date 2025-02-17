output "kubernetes_provider_config" {
  value = module.gke.kubernetes_provider_config
  sensitive = true
}
