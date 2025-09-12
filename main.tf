provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca)
  token                  = var.cluster_token
}

# Strapi Deployment
resource "kubernetes_deployment" "strapi" {
  metadata {
    name   = "strapi"
    labels = { app = "strapi" }
  }

  spec {
    replicas = 3

    selector {
      match_labels = { app = "strapi" }
    }

    template {
      metadata {
        labels = { app = "strapi" }
      }

      spec {
        container {
          name  = "strapi"
          image = "faisalkhan35/strapi-app:latest"

          ports {
            container_port = 1337
          }
        }
      }
    }
  }
}

# LoadBalancer Service
resource "kubernetes_service" "strapi" {
  metadata {
    name = "strapi-service"
  }

  spec {
    selector = {
      app = kubernetes_deployment.strapi.metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 1337
    }

    type = "LoadBalancer"
  }
}
