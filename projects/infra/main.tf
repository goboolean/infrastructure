terraform {
  backend "gcs" {
    bucket = "goboolean-450909-terraform-state"
    prefix = "infra"
  }
}

module "argocd" {
  source = "../../modules/infra/argocd"
}

module "kafka" {
  source = "../../modules/infra/kafka"
}

module "etcd" {
  source = "../../modules/infra/etcd"
}

module "opentelemetry" {
  source = "../../modules/infra/opentelemetry"
}

/*
  The following infrastructure depends on Vault.
  Therefore, it should be separated into a distinct module
  and divided into stages.
*/
# module "argocd-application" {
#   source = "../../modules/infra/argocd/application"
#   depends_on = [module.argocd, module.namespace]
#   providers = {
#     argocd = argocd
#   }
# }
/*
data "vault_kv_secret_v2" "harbor" {
  mount = "kv"
  name = "infra/harbor"
}

module "harbor" {
  source = "../../modules/infra/harbor"
  harbor_username = data.vault_kv_secret_v2.harbor.data["username"]
  harbor_password = data.vault_kv_secret_v2.harbor.data["password"]
  providers = {
    harbor = harbor
  }
}
*/
data "vault_kv_secret_v2" "postgresql" {
  mount = "kv"
  name = "infra/postgresql"
}

module "postgresql" {
  source = "../../modules/infra/postgresql"
  postgresql_username = data.vault_kv_secret_v2.postgresql.data["username"]
  postgresql_password = data.vault_kv_secret_v2.postgresql.data["password"]
}

data "vault_kv_secret_v2" "influxdb" {
  mount = "kv"
  name = "infra/influxdb"
}

module "influxdb" {
  source = "../../modules/infra/influxdb"
  influxdb_username = data.vault_kv_secret_v2.influxdb.data["username"]
  influxdb_password = data.vault_kv_secret_v2.influxdb.data["password"]
  influxdb_token = data.vault_kv_secret_v2.influxdb.data["token"]
}

module "telegraf" {
  source = "../../modules/infra/fetch-system/telegraf"
  influxdb_token = data.vault_kv_secret_v2.influxdb.data["token"]
}

data "vault_kv_secret_v2" "grafana" {
  mount = "kv"
  name = "infra/grafana"
}

# module "grafana" {
#   source = "../../modules/infra/grafana"
#   depends_on = [module.namespace]
#   grafana_username = data.vault_kv_secret_v2.grafana.data["username"]
#   grafana_password = data.vault_kv_secret_v2.grafana.data["password"]
#   influxdb_token = data.vault_kv_secret_v2.influxdb.data["token"]
# }

module "kube-prometheus-stack" {
  source = "../../modules/infra/monitoring/kube-prometheus-stack"
  grafana_username = data.vault_kv_secret_v2.grafana.data["username"]
  grafana_password = data.vault_kv_secret_v2.grafana.data["password"]
}

data "vault_kv_secret_v2" "airflow" {
  mount = "kv"
  name = "infra/airflow"
}

module "airflow" {
  source = "../../modules/infra/airflow"
  airflow_username = data.vault_kv_secret_v2.airflow.data["username"]
  airflow_password = data.vault_kv_secret_v2.airflow.data["password"]
  postgres_host = "postgresql.postgresql.svc.cluster.local"
  postgres_user = data.vault_kv_secret_v2.postgresql.data["username"]
  postgres_password = data.vault_kv_secret_v2.postgresql.data["password"]
}

module "loki-stack" {
  source = "../../modules/infra/monitoring/loki-stack"
  project_id = var.project_id
}

module "dex" {
  source = "../../modules/infra/dex"
}
