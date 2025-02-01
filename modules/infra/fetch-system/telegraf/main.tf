resource "helm_release" "telegraf" {
  name       = "telegraf"
  repository = "https://helm.influxdata.com/"
  chart      = "telegraf"
  namespace  = "fetch-system"
  version    = "1.8.55"

  values = [
    file("${path.module}/values.yaml")
  ]
}