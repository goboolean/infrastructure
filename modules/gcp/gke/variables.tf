variable "gke_num_nodes" {
  default     = 3
}

variable "gke_machine_type" {
  default     = "e2-standard-4"
}

variable "gke_disk_size_gb" {
  default     = 50
}

variable "gke_version" {
  default     = "1.31.4-gke.1372000"
}
