terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.84.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.0.0-rc1"
    }

    acme = {
      source = "vancluever/acme"
      version = "2.29.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }

    /*
      It is not possible to deploy all infrastructure with a single main.tf.
      Therefore, the steps need to be divided,
      and the following variables can be injected starting from the second step,
      so they should be moved later.
    */
    vault = {
      source  = "hashicorp/vault"
      version = "4.6.0"
    }

    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.3.0"
    }
  }
  required_version = ">= 0.14"
}

provider "google" {
  project = var.project_id
  region = var.region
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "kubernetes" {
  host                   = module.gke.kubernetes_provider_config.host
  token                  = module.gke.kubernetes_provider_config.token
  cluster_ca_certificate = module.gke.kubernetes_provider_config.cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    host                   = module.gke.kubernetes_provider_config.host
    token                  = module.gke.kubernetes_provider_config.token
    cluster_ca_certificate = module.gke.kubernetes_provider_config.cluster_ca_certificate
  }
}

provider "acme" {
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

provider "kubectl" {
  host                   = module.gke.kubernetes_provider_config.host
  token                  = module.gke.kubernetes_provider_config.token
  cluster_ca_certificate = module.gke.kubernetes_provider_config.cluster_ca_certificate
  load_config_file       = false
}

/*
  It is not possible to deploy all infrastructure with a single main.tf.
  Therefore, the steps need to be divided,
  and the following variables can be injected starting from the second step,
  so they should be moved later.
*/
provider "vault" {
  address = "https://vault.goboolean.io"
  auth_login {
    path = "auth/approle/login"
    parameters = {
      role_id   = var.vault_role_id
      secret_id = var.vault_secret_id
    }
  }
}

data "vault_kv_secret_v2" "argocd" {
  mount = "kv-v2"
  name = "infra/argocd"
}

provider "argocd" {
  server_addr = "argocd.goboolean.io:443"
  username = data.vault_kv_secret_v2.argocd.data["username"]
  password = data.vault_kv_secret_v2.argocd.data["password"]
}
