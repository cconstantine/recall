provider "aws" {

}

terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  # config_context = "default"
}

provider "helm" {

  kubernetes {
    config_path = "~/.kube/config"
  }

}