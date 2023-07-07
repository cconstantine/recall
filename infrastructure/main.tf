module "eks" {
    source = "./terraform-aws-eks"
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_security_group_id
}

output "region" {
  description = "AWS region"
  value       = "us-west-2"
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

resource "helm_release" "alb_controller" {
  name       = "aws-load-balancer"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  timeout = 1200
  set {
    name  = "region"
    value = "us-west-2"
  }

  set {
    name = "vpcId"
    value = module.eks.vpc_id
  }
  
  set {
    name = "clusterName"
    value = "recall"
  }
}