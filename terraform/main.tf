provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# Fetch EKS cluster info
data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
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

          port {
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
