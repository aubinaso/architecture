output "deploy_wordpress_name" {
  value = kubernetes_deployment.wp-deb-wordpress.metadata[0].name
}
