# Google Cloud Platform
variable "project_id" {
  description = "project id"
}
variable "region" {
  description = "region"
}
variable "zone" {
  description = "zone"
}
variable "location" {
  description = "location"
}

/*
  The following infrastructure depends on Vault.
  Therefore, it should be separated into a distinct module
  and divided into stages.
*/
