terraform {
  required_providers {
    vultr = {
      source = "vultr/vultr"
      version = "2.30.1"
    }
  }
}

provider "vultr" {
  api_key = var.vultr_api_key
  rate_limit = 100
  retry_limit = 3
}

resource "vultr_kubernetes" "k8" {
    region  = "ewr"
    label   = "vke-test"
    version = "v1.35.2+1"

    node_pools {
        node_quantity = 1
        plan          = "vc2-2c-4gb"
        label         = "vke-nodepool"
        auto_scaler   = true
        min_nodes     = 1
        max_nodes     = 3
    }
}

data "vultr_kubernetes" "k8" {
  filter {
    name = "label"
    values = ["vke-test"]
  }
  depends_on = [vultr_kubernetes.k8]
}

output "kubeconfig" {
  value = data.vultr_kubernetes.k8.kube_config
  sensitive = true
}
