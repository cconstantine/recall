provider "aws" {

}

terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

# provider "kubernetes" {
#   host = module.eks.cluster_endpoint

#   client_certificate     = base64decode(module.eks.cluster_certificate_authority_data)
# #   client_key             = base64decode(module.eks.cluster_tls_certificate_sha1_fingerprint)
# #   cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
# }
provider "kubernetes" {
  config_path    = "~/.kube/config"
#   config_context = "default"
}
