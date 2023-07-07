resource "kubernetes_namespace" "recall" {
  metadata {
    name = "recall"
  }
}

resource "kubernetes_cluster_role" "api-server" {
  metadata {
    name = "api-server-role"
  }

  # Wildly too permissive
  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_service_account" "api-server" {
  metadata {
    name      = "api-server-service-account"
    namespace = kubernetes_namespace.recall.metadata.0.name
  }
}

resource "kubernetes_cluster_role_binding" "api-server" {
  metadata {
    name = "api-server-cluster-role-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.api-server.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.api-server.metadata.0.name
    namespace = kubernetes_namespace.recall.metadata.0.name
  }
}

resource "kubernetes_deployment" "api-server" {
  timeouts {
    create = "1m"
    delete = "1m"
    update = "1m"
  }
  metadata {
    name = "api-server"
    namespace = kubernetes_namespace.recall.metadata.0.name
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        name = "api-server"
      }
    }
    template {
      metadata {
        labels = {
          name = "api-server"
        }
      }
      spec {
        toleration {
            key = "eks.amazonaws.com/compute-type"
            value = "fargate"
        }
        service_account_name = kubernetes_service_account.api-server.metadata.0.name
        container {
          image = var.docker_image
          name  = "example"

          command = [
            "python3", "./api-server/main.py"
          ]

          port {
            container_port = 8888
          }

          env {
            name = "JOB_IMAGE_URI"
            value = var.docker_image
          }
          env {
            name = "JOB_NAMESPACE"
            value = kubernetes_namespace.recall.metadata.0.name
          }
          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }


        }
      }
    }
  }
}

resource "kubernetes_service" "api-server" {
  metadata {
    name      = "api-server"
    namespace = kubernetes_namespace.recall.metadata.0.name
  }
  spec {
    selector = {
      name = "api-server"
    }
    port {
      port = 8888
    }
  }
}

resource "kubernetes_ingress_v1" "api-server" {
  metadata {
    name      = "api-server-ingress"
    namespace = kubernetes_namespace.recall.metadata.0.name
    annotations = {
      "alb.ingress.kubernetes.io/scheme": "internet-facing"
      "kubernetes.io/ingress.class": "alb"
    }
  }

  spec {
    rule {
      host = "api-server.homelab"
      http {
        path {
          backend {
            service {
              name = kubernetes_service.api-server.metadata.0.name
              port {
                number = 8888
              }
            }
          }
        }
      }
    }
  }
}
