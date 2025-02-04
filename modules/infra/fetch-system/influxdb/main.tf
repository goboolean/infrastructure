locals {
  values_yaml = templatefile("${path.module}/values.yaml", {
    username = var.influxdb_username
    password = var.influxdb_password
    token = var.influxdb_token
  })
}

resource "helm_release" "influxdb" {
  name             = "influxdb"
  chart            = "influxdb2"
  namespace        = "influxdata"
  repository       = "https://helm.influxdata.com"
  version          = "2.1.2"
  
  values = [local.values_yaml]

  timeout = 600
}

resource "kubernetes_manifest" "influxdb-gateway" {
  manifest = yamldecode(file("${path.module}/gateway.yaml"))
  depends_on = [helm_release.influxdb]
}
