terraform {
  backend "gcs" {
    bucket = "goboolean-450909-terraform-state"
    prefix = "452007/k8s/infra/deployments"
  }
}

data "vault_kv_secret_v2" "harbor" {
  mount = "kv"
  name = "infra/harbor"
}

module "harbor" {
  source = "../../../../modules/infra/harbor"
  harbor_username = data.vault_kv_secret_v2.harbor.data["username"]
  harbor_password = data.vault_kv_secret_v2.harbor.data["password"]
}

module "kafka" {
  source = "../../../../modules/infra/kafka"
  depends_on = [module.kube-prometheus-stack]
}

module "etcd" {
  source = "../../../../modules/infra/etcd"
}

module "opentelemetry" {
  source = "../../../../modules/infra/opentelemetry"
}

data "vault_kv_secret_v2" "argocd" {
  mount = "kv"
  name = "infra/argocd"
}

module "argocd" {
  source = "../../../../modules/infra/argocd"
  admin_password = data.vault_kv_secret_v2.argocd.data["password"]
}


data "vault_kv_secret_v2" "postgresql" {
  mount = "kv"
  name = "infra/postgresql"
}

module "postgresql" {
  source = "../../../../modules/infra/postgresql"
  postgresql_username = data.vault_kv_secret_v2.postgresql.data["username"]
  postgresql_password = data.vault_kv_secret_v2.postgresql.data["password"]
}

data "vault_kv_secret_v2" "influxdb" {
  mount = "kv"
  name = "infra/influxdb"
}

module "influxdb" {
  source = "../../../../modules/infra/influxdb"
  influxdb_username = data.vault_kv_secret_v2.influxdb.data["username"]
  influxdb_password = data.vault_kv_secret_v2.influxdb.data["password"]
  influxdb_token = data.vault_kv_secret_v2.influxdb.data["token"]
}

data "vault_kv_secret_v2" "grafana" {
  mount = "kv"
  name = "infra/grafana"
}

module "kube-prometheus-stack" {
  source = "../../../../modules/infra/monitoring/kube-prometheus-stack"
  grafana_username = data.vault_kv_secret_v2.grafana.data["username"]
  grafana_password = data.vault_kv_secret_v2.grafana.data["password"]
}

data "vault_kv_secret_v2" "airflow" {
  mount = "kv"
  name = "infra/airflow"
}

module "airflow" {
  source = "../../../../modules/infra/airflow"
  airflow_username = data.vault_kv_secret_v2.airflow.data["username"]
  airflow_password = data.vault_kv_secret_v2.airflow.data["password"]
  postgres_host = "postgresql.postgresql.svc.cluster.local"
  postgres_user = data.vault_kv_secret_v2.postgresql.data["username"]
  postgres_password = data.vault_kv_secret_v2.postgresql.data["password"]
}

module "loki-stack" {
  source = "../../../../modules/infra/monitoring/loki-stack"
  project_id = var.project_id
}

module "dex" {
  source = "../../../../modules/infra/dex"
}

data "vault_kv_secret_v2" "github" {
  mount = "kv"
  name = "github"
}

data "vault_kv_secret_v2" "atlantis" {
  mount = "kv"
  name = "infra/atlantis"
}

module "atlantis" {
  source = "../../../../modules/infra/atlantis"

  project_id = var.project_id
  github_username = "goboolean-io"
  github_token = data.vault_kv_secret_v2.github.data["admin_token"]
  webhook_secret = data.vault_kv_secret_v2.github.data["atlantis_webhook_secret"]
  username = data.vault_kv_secret_v2.atlantis.data["username"]
  password = data.vault_kv_secret_v2.atlantis.data["password"]
}

module "kiali" {
  source = "../../../../modules/infra/kiali"

  grafana_username = data.vault_kv_secret_v2.grafana.data["username"]
  grafana_password = data.vault_kv_secret_v2.grafana.data["password"]
}

module "redis" {
  source = "../../../../modules/infra/redis"
}
