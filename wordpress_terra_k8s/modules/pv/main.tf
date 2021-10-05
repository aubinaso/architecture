resource "kubernetes_persistent_volume" "wordpress-pv" {
  metadata {
    name = "pv-${var.pvpvc-name}"
    labels = {
      app = var.wordpress-deb 
      tier = var.frontend
    }
  }
  spec {
    capacity = {
      storage = var.pv-size
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      server = var.server-nfs
      path = var.pvpvc-dir
      type = var.pvpvc-type
    }
  }
}
