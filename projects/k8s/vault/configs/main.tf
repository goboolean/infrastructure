terraform {
  backend "gcs" {
    bucket = "goboolean-450909-tfstate"
    prefix = "452007/k8s/vault/configs"
  }
}

module "vault_config" {
  source = "../../../../modules/infra/vault/config"
  token_reviewer_jwt = local.token_reviewer_jwt
  kubernetes_host = local.gke_host
  kubernetes_ca_cert = local.gke_cluster_ca_certificate
  providers = {
    vault = vault
  }
}
