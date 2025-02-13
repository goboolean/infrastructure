locals {
  values_yaml = templatefile("${path.module}/values.yaml", {
    username = var.airflow_username
    password = var.airflow_password

    postgres_host = var.postgres_host
    postgres_user = var.postgres_user
    postgres_password = var.postgres_password
  })
}

resource "helm_release" "airflow" {
  name             = "airflow"
  chart            = "airflow"
  namespace        = "airflow"
  repository       = "https://airflow-helm.github.io/charts"
  version          = "8.9.0"
  
  values = [local.values_yaml]
}

resource "kubernetes_manifest" "airflow-sa" {
  manifest = yamldecode(file("${path.module}/sa.yaml"))
}

resource "kubernetes_manifest" "airflow-cluster-role" {
  manifest = yamldecode(file("${path.module}/cluster-role.yaml"))
}

resource "kubernetes_manifest" "airflow-cluster-role-binding" {
  manifest = yamldecode(file("${path.module}/cluster-role-binding.yaml"))
}

resource "kubernetes_manifest" "airflow-gateway" {
  manifest = yamldecode(file("${path.module}/gateway.yaml"))
}
