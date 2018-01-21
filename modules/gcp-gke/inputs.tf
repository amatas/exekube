variable "gcp_zone" {
  default = "europe-west1-d"
}

variable "gcp_region" {
  default = "europe-west1"
}

variable "gcp_project" {}

# ------------------------------------------------------------------------------
# Cluster vars
# ------------------------------------------------------------------------------

variable "cluster_name" {
  default = "k8s-cluster"
}

variable "node_type" {
  default = "n1-standard-2"
}

variable "gke_version" {
  default = "1.8.4-gke.1"
}

variable "enable_legacy_auth" {
  default = "false"
}

# ------------------------------------------------------------------------------
# Node pool vars
# ------------------------------------------------------------------------------

variable "nodepool_name" {
  default = "k8s-nodepool"
}

variable "nodepool_max_nodes" {
  default = 4
}

variable "nodepool_machine_type" {
  default = "n1-standard-2"
}
