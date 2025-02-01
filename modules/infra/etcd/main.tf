resource "helm_release" "etcd" {
  name             = "etcd"
  chart            = "etcd"
  namespace        = "etcd"
  repository       = "oci://registry-1.docker.io/bitnamicharts"
  version          = "11.0.5"
  
  values = [file("${path.module}/values.yaml")]

  timeout = 600
}
