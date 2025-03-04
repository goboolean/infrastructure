module "harbor-policy" {
  source = "../../../../modules/infra/harbor/policy"
  providers = {
    harbor = harbor
  }
}

module "argocd-application" {
  source = "../../../../modules/infra/argocd/application"
  providers = {
    argocd = argocd
  }
}
