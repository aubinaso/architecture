output "secret_name" {
  value = kubernetes_secret.mysql.metadata[0].name
}
