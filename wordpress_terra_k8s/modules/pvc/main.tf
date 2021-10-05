resource "kubernetes_persistent_volume_claim" "wp-pv" {
  metadata {
    name = "pvc-${var.pvpvc-name}"
    app = var.wordpress-deb
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources = {
      request = {
        storage = var.pvc-size
      }
    }
  }
  volume_name = var.volume_name
}
