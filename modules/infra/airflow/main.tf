locals {
  values_yaml = templatefile("${path.module}/values.yaml", {
    username = var.airflow_username
    password = var.airflow_password
  })
}

resource "helm_release" "airflow" {
  name             = "airflow"
  chart            = "airflow"
  namespace        = "airflow"
  repository       = "https://airflow-helm.github.io/charts"
  version          = "8.9.0"
  
  values = [local.values_yaml]

  timeout = 600
}

resource "kubernetes_manifest" "airflow-gateway" {
  manifest = yamldecode(file("${path.module}/gateway.yaml"))
  depends_on = [helm_release.airflow]
}
