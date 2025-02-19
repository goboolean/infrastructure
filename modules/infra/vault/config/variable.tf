variable "token_reviewer_jwt" {
  description = "token reviewer jwt"
  sensitive = true
}

variable "kubernetes_host" {
  description = "kubernetes host"
  sensitive = true
}

variable "kubernetes_ca_cert" {
  description = "kubernetes ca cert"
  sensitive = true
}
