locals {
  values_yaml = templatefile("${path.module}/values.yaml", {
    influxdb_token = var.influxdb_token
  })
}

resource "helm_release" "telegraf" {
  name       = "telegraf-ds"
  chart      = "telegraf-ds"
  namespace  = "influxdata"
  repository = "https://helm.influxdata.com/"
  version    = "1.1.35"

  values = [local.values_yaml]
}
