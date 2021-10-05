resource "kubernetes_deployment" "wp-deb-mysql" {
  metadata {
    name = "wp-dep-mysql"
    labels = {
      app = wordpress-deb
    }
  }
  spec {
    replicas = var.replicas
    selector {
      match_labels = {
        app = var.wordpress-deb
        tier = var.mysql-lbl
      }
    }
    strategy = {
      type = "Recreate"
    }
    template {
      metadata {
        labels = {
          app = var.wordpress-deb
          tier = var.mysql-lbl
        }
      }
      spec {
        container {
          image = var.mysql-image
          name = "wp-mysql"
          env {
            name = "MYSQL_ROOT_PASSWORD"
            value_from {
              name = var.secret_name
              key = var.mysql-password
            }
          }
          port {
            container_port = var.mysql-port
            name = "mysql"
          }
          volume_mount {
            name = "mysql-persistent-storage"
            mount_path = "/var/lib/mysql"
          }
        }
        volume {
          name = "mysql-persistent-storage"
          persistent_volume_claim {
            claim_name = var.volume_claim_name
          }
        }
      }
    }
  }
}
