resource "kubernetes_deployment" "wp-deb-wordpress" {
  metadata {
    name = "wp-deb-wordpress"
    labels = {
      app = var.wordpress-deb
    }
  }
  spec {
    replicas = var.replicas
    selector {
      match_labels = {
        app = var.wordpress-deb
        tier = var.frontend
      }
    }
    strategy = "Recreate"
    template {
      metadata {
        labels = {
          app = var.wordpress-deb
          tier = var.frontend
        }
      }
      spec {
        container {
          image = var.wordpress-image
          name = "wordpress"
          env {
            name = WORDPRESS_DB_HOST
            value = var.deploy_mysql_name
          }
          env {
            name = WORDPRESS_DB_PASSWORD
            value_from {
              secret_key_ref {
                name = var.secret_name
                key = var.mysql-pass
              }
            }
          }
          port {
            port = var.wordpress-port
            name = "wordpress"
          }
          volume_mount {
            name = "wordpress-persistent-storage"
            mount_path = var.wordpress-dir
          }
        }
        volume {
          name = "wordpress-persistent-storage"
          persistent_volume_claim {
            claim_name = var.volume_claim_name
          }
        }
      }
    }
  }
}
