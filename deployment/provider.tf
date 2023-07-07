
terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }

  backend "kubernetes" {
    secret_suffix = "recallstate"
    config_path   = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
}
