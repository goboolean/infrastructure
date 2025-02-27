variable "gke_num_nodes" {
  default     = 4
}

variable "gke_machine_type" {
  default     = "e2-standard-4"
}

variable "gke_disk_size_gb" {
  default     = 50
}

variable "gke_version" {
  default     = "1.31.5-gke.1068000"
}
