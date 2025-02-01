output "admin_username" {
  value = "admin"
}

output "admin_password" {
  value = data.kubernetes_secret.argocd_initial_password.data.password
  sensitive = true
}
