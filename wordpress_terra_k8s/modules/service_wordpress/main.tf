resource "kubernetes_service" "wp-svc-wordpress" {
  metadata {
    name = "wp-svc-wordpress"
    labels = {
      app = var.wordpress-deb
    }
  }
  spec {
    port {
      port = var.wordpress-port
      target_port = var.wordpress-target-port
      node_port = var.wordpress-node-port
      name = var.port-name
    }
    selector = {
      app = var.wordpress-deb
      tier = var.wordpress-frontend
    }
    type = "NodePort"
  }
}
