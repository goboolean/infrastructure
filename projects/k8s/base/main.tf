module "storageclass" {
  source = "../../../modules/gcp/gke/storageclass"
}

module "namespace" {
  source = "../../../modules/gcp/gke/namespace"
}
