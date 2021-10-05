output "volume_claim_name" {
  value = kubernetes_persistent_volume_claim.wp-pv.metadata[0].name
}
