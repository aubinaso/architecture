output "service_mysql_name" {
  value = kubernetes_service.wp-svc-mysql.metadata[0].name
}
