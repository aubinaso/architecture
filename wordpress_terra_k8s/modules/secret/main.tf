resource "kubernetes_secret" "mysql" {
  metadata {
    name = "mysql-pass"
  }
  type = "opaque"
  data = {
    password = var.mysql-pass
  }
}
