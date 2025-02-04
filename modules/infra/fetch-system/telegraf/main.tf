locals {
  values_yaml = templatefile("${path.module}/values.yaml", {
    influxdb_token = var.influxdb_token
  })
}

resource "helm_release" "telegraf" {
  name       = "telegraf"
  repository = "https://helm.influxdata.com/"
  chart      = "telegraf"
  namespace  = "fetch-system"
  version    = "1.8.55"

  values = [local.values_yaml]
}
