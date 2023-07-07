
terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }

  backend "kubernetes" {
    secret_suffix = "recallstate"
    config_path   = "~/.kube/homelab-config2"
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/homelab-config2"
  config_context = "default"
}
