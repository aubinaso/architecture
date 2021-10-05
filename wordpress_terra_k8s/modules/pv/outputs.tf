output "volume_name" {
  value = kubernetes_persistent_volume.wordpress-pv.metadata[0].name
}
