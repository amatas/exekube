# ------------------------------------------------------------------------------
# CloudFlare input variables
# ------------------------------------------------------------------------------

variable "cloudflare" {
  type = "map"

  default = {
    email = ""
    token = ""
  }
}

variable "cluster_dns_zones" {
  type = "list"

  default = []
}

# ------------------------------------------------------------------------------
# Helm input variables
# ------------------------------------------------------------------------------

variable "kube_lego" {
  type = "map"

  default = {
    enabled     = true
    values_file = "values/kube-lego.yaml"
  }
}

variable "ingress_controller" {
  type = "map"

  default = {
    enabled     = true
    values_file = "values/ingress-controller.yaml"
  }
}
