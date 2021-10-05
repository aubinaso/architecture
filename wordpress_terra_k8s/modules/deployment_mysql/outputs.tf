output "deploy_mysql_name" {
  value = kubernetes_deployment.wp-deb-mysql.metadata[0].name
}
