# ------------------------------------------------------------------------------
# TERRAFORM / PROVIDER CONFIG
# ------------------------------------------------------------------------------

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "gcs" {}
}

provider "google" {
  project     = "${var.project_id}"
  credentials = "${var.serviceaccount_key}"
}

# ------------------------------------------------------------------------------
# GOOGLE KUBERNTES ENGINE CLUSTER
# ------------------------------------------------------------------------------

resource "google_container_cluster" "cluster" {
  name = "${var.cluster_name}"
  zone = "${var.main_compute_zone}"

  additional_zones = "${var.additional_zones}"

  initial_node_count = "${var.initial_node_count}"
  node_version       = "${var.kubernetes_version}"
  min_master_version = "${var.kubernetes_version}"
  enable_legacy_abac = "false"
  network            = "${var.network_name}"
  subnetwork         = "nodes"

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }

    kubernetes_dashboard {
      disabled = false
    }

    http_load_balancing {
      disabled = false
    }

    network_policy_config {
      disabled = false
    }
  }

  node_config {
    machine_type = "${var.node_type}"
    disk_size_gb = 200
    oauth_scopes = "${var.oauth_scopes}"

    labels {
      project = "${var.project_id}"
      pool    = "default"
    }
  }

  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  lifecycle {
    create_before_destroy = true
  }

  provisioner "local-exec" {
    command = <<EOF
gcloud auth activate-service-account --key-file ${var.serviceaccount_key} \
&& gcloud container clusters get-credentials ${var.cluster_name} \
--zone ${var.main_compute_zone} \
--project ${var.project_id} \
&& kubectl label ns kube-system name=kube-system \
&& kubectl create clusterrolebinding \
creator-cluster-admin-binding \
--clusterrole=cluster-admin \
--user=$(gcloud info --format='value(config.account)') \
&& helm init --client-only
EOF
  }
}
