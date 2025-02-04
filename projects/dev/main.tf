terraform {
  backend "gcs" {
    bucket = "goboolean-terraform-state"
    prefix = "dev"
  }
}

module "service" {
  source = "../../modules/gcp/service"
  project_id = var.project_id
}

module "iam" {
  source = "../../modules/gcp/iam"
  project_id = var.project_id
  region = var.region
}

module "gce" {
  source = "../../modules/gcp/gce"
  zone = var.zone
  service_account_email = module.iam.atlantis_service_account_email
}

module "cloudflare" {
  source = "../../modules/cloudflare"
  api_token = var.cloudflare_api_token
  zone_id = var.cloudflare_zone_id
  ip_address = module.istio.istio_gateway_ip
}

module "acme" {
  source = "../../modules/cloudflare/acme"

  cloudflare_email = var.cloudflare_email
  cloudflare_api_token = var.cloudflare_api_token
  cloudflare_zone_id = var.cloudflare_zone_id
  cloudflare_api_key = var.cloudflare_api_key
}

module "gcs" {
  source = "../../modules/gcp/gcs"
  project_id = var.project_id
  location = var.location
}

module "gke" {
  source = "../../modules/gcp/gke"
  region = var.region
  project_id = var.project_id
  zone = var.zone
}

module "namespace" {
  source = "../../modules/gcp/gke/namespace"
}

module "istio" {
  source = "../../modules/infra/istio"
  depends_on = [module.gke, module.namespace]
}

module "cert_manager" {
  source = "../../modules/infra/cert-manager"
  depends_on = [module.gke, module.namespace]
  cloudflare_api_token = var.cloudflare_api_token
}

module "vault" {
  source = "../../modules/infra/vault"
  depends_on = [module.gke, module.namespace]
}

module "argocd" {
  source = "../../modules/infra/argocd"
  depends_on = [module.gke, module.namespace]
}

module "kafka" {
  source = "../../modules/infra/kafka"
  depends_on = [module.gke, module.namespace]
}

module "etcd" {
  source = "../../modules/infra/etcd"
  depends_on = [module.gke, module.namespace]
}

module "opentelemetry" {
  source = "../../modules/infra/opentelemetry"
  depends_on = [module.gke, module.namespace]
}

module "harbor" {
  source = "../../modules/infra/harbor"
  depends_on = [module.gke, module.namespace]
}

/*
  It is not possible to deploy all infrastructure with a single main.tf.
  Therefore, the steps need to be divided,
  and the following variables can be injected starting from the second step,
  so they should be moved later.
*/
# module "argocd-application" {
#   source = "../../modules/infra/argocd/application"
#   depends_on = [module.argocd, module.namespace]
#   providers = {
#     argocd = argocd
#   }
# }

data "vault_kv_secret_v2" "postgresql" {
  mount = "kv-v2"
  name = "infra/postgresql"
}

module "postgresql" {
  source = "../../modules/infra/postgresql"
  depends_on = [module.gke, module.namespace]
  postgresql_username = data.vault_kv_secret_v2.postgresql.data["username"]
  postgresql_password = data.vault_kv_secret_v2.postgresql.data["password"]
}

# module "fetch-system-util" {
#   source = "../../modules/infra/argocd/job/fetch-system.util"
#   depends_on = [module.argocd, module.postgresql, module.namespace]
#   providers = {
#     argocd = argocd
#   }
# }

data "vault_kv_secret_v2" "influxdb" {
  mount = "kv-v2"
  name = "infra/influxdb"
}

module "influxdb" {
  source = "../../modules/infra/fetch-system/influxdb"
  depends_on = [module.gke, module.namespace]
  influxdb_username = data.vault_kv_secret_v2.influxdb.data["username"]
  influxdb_password = data.vault_kv_secret_v2.influxdb.data["password"]
}
