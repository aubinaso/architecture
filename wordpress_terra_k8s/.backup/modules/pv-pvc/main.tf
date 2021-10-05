resource "kubernetes_persistent_volume" "wp-pv" {
  metadata {
    name = "pv-${var.pvpvc-name}"
  }
  spec {
    capacity = {
      storage = var.pvpvc-size
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      host_path {
        path = var.pvpvc-dir
        type = var.pvpvc-type
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "wp-pv" {
  metadata {
    name = "pvc-${var.pvpvc-name}
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      request = {
        storage = var.pvpvc-size
      }
    }
    volume_name = kubernetes_persistent_volume.wp-pv.metadate[0].name
  }
}
