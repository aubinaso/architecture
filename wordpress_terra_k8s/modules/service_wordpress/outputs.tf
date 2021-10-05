output "service_wordpress_name" {
  value = kubernetes_service.wp-svc-wordpress.metadata[0].name
}
