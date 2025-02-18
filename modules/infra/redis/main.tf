resource "helm_release" "redis" {
  name       = "redis"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "redis"
  version    = "20.7.1"
  namespace  = "redis"

  values = [
    file("${path.module}/values.yaml")
  ]
}
