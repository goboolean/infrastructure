module "cert_manager" {
  source = "../../../../modules/infra/cert-manager"
}

module "istio" {
  source = "../../../../modules/infra/istio"
}

