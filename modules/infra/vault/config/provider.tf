terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "4.6.0"
    }
  }
  required_version = ">= 0.14"
}
