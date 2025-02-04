locals {
  values_yaml = templatefile("${path.module}/values.yaml", {
    username = var.influxdb_username
    password = var.influxdb_password
  })
}

resource "helm_release" "influxdb" {
  name             = "influxdb"
  chart            = "influxdb2"
  namespace        = "influxdb"
  repository       = "https://helm.influxdata.com"
  version          = "2.1.2"
  
  values = [local.values_yaml]

  timeout = 600
}
