provider "kubernetes" {
  config_path    = "~/.kube/config"
}

resource "kubernetes_deployment" "was-application" {
  metadata {
    name = "was-application"
    namespace = "default"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "was-application"
      }
    }
    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "was-application"
        }
      }
      spec {
        container {
          name  = "was"
          image = "621895435515.dkr.ecr.us-west-2.amazonaws.com/was:latest"
          image_pull_policy = "Always"
          port {
            container_port = 8080
          }
          resources {
            requests = {
              cpu = "500m"
              memory = "200Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "was-service" {
  metadata {
    name = "was-service"
  }
  spec {
    selector = {
      "app.kubernetes.io/name" = "was-application"
    }
    port {
      port        = 8080
      target_port = 8080
    }
    type = "NodePort"
  }
}

resource "kubernetes_ingress_v1" "alb" {
  metadata {
    name = "alb"
    annotations = {
      "alb.ingress.kubernetes.io/scheme"      = "internet-facing",
      "alb.ingress.kubernetes.io/target-type" = "ip",
    }
  }
  spec {
    ingress_class_name = "alb"
    rule {
      http {
        path {
          path_type = "Prefix"
          backend {
            service {
              name = "was-service"
              port {
                number = 8080
              }
            }
          }
          path = "/"
        }
      }
    }
  }
}
