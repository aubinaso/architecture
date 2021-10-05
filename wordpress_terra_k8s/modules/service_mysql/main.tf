resource "kubernetes_service" "wp-svc-mysql" {
  metadata {
    name = "wp-mysql"
    labels = {
      app = var.wordpress-deb
    }
  }
  spec {
    port {
      port = var.mysql-port
    }
    selector = {
      app = var.mysql-lbl
    }
    cluster_ip = "None"
  }
}

