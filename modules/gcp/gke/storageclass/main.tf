resource "kubernetes_annotations" "standard_rwo" {
  api_version = "storage.k8s.io/v1"
  kind        = "StorageClass"
  metadata {
    name = "standard-rwo"
  }
  annotations = {
    "storageclass.kubernetes.io/is-default-class" = "false"
  }
  force = true
}

resource "kubernetes_annotations" "standard" {
  api_version = "storage.k8s.io/v1"
  kind        = "StorageClass"
  metadata {
    name = "standard"
  }
  annotations = {
    "storageclass.kubernetes.io/is-default-class" = "true"
  }
  force = true
}
