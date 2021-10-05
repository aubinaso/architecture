variable mysql-image {}
variable wordpress-image {}
variable mysql-pass {}
variable pvpvc-name {}
variable pv-size {}
variable pvpvc-dir {}
variable server-nfs {}
variable pvpvc-type {}
variable wordpress-deb {}
variable frontend {}
variable pvc-size {}
variable mysql-port {}
variable mysql-lbl {}
variable wordpress-port {}
variable wordpress-target-port {}
variable node-ip-port {}
variable wordpress-port-name {}
variable replicas {}
# variable secret_name {}
# variable volume_name {}
# variable volume_claim_name {}
# variable service_wordpress_name {}
# variable deploy_mysql_name {}
# variable deploy_wordpress_name {}

resource "null_resource" "install_nfs-utils" {

  provisioner "local-exec" {
    command = "apt install nfs-utils -y"
  }
  provisioner "local-exec" {
    command = "mkdir /{mysql,html}"
  }

  provisioner "local-exec" {# ici il faut les changer en leur variable
    command = "chmod -R 755 /{mysql,html}"
  }

  provisioner "local-exec" {
    command = "chown nfsnobody:nfsnobody /{mysql,html}"
  }

  provisioner "local-exec" {
    command = "systemctl enable rpcbind; systemctl enable nfs-server"
  }

  provisioner "local-exec" {
    command = "systemctl enable nfs-lock; systemctl enable nfs-idmap"
  }

  provisioner "local-exec" {
    command = "systemctl start rpcbind; systemctl start nfs-server"
  }

  provisioner "local-exec" {
    command = "systemctl start nfs-lock; systemctl start nfs-idmap"
  }
}

provider "kubernetes" {
  load_config_file = true
}
  
module "module_pv" {
  source = "./modules/pv"
  pvpvc-name = var.pvpvc-name
  pvpvc-type = var.pvpvc-type
  pvpvc-dir = var.pvpvc-dir
  pv-size = var.pv-size
  server-nfs = var.server-nfs
  wordpress-deb = var.wordpress-deb
  frontend = var.frontend
}

module "module_pvc" {
  source = "./modules/pvc"
  pvpvc-name = var.pvpvc-name
  pvc-size = var.pvc-size
  wordpress-deb = var.wordpress-deb
  volume_name = module.module_pv.volume_name
}

module "module_secret" {
  source = "./modules/secret"
  mysql-pass = var.mysql-pass 
}

module "module_service_mysql" {
  source = "./modules/service_mysql"
  mysql-port = var.mysql-port
  mysql-lbl = var.mysql-lbl 
  wordpress-deb = var.wordpress-deb
}

module "module_service_wordpress" {
  source = "./modules/service_wordpress"
  wordpress-target-port = var.wordpress-target-port 
  wordpress-deb = var.wordpress-deb 
  wordpress-frontend = var.frontend 
  wordpress-port = var.wordpress-port 
  node-ip-address = var.node-ip-port 
}

module "module_deploy_mysql" {
  source = "./modules/deployment_mysql"
  mysql-image = var.mysql-image
  secret_name = module.module_secret.secret_name
  mysql-pass = var.mysql-pass
  volume_claim_name = module.module_pvc.volume_claim_name
  mysql-port = var.mysql-port
  wordpress-deb = var.wordpress-deb
  mysql-lbl = var.mysql-lbl
  replicas = var.replicas
}

module "module_deploy_wordpress" {
  source = "./modules/deployment_wordpress"
  deploy_mysql_name = module.module_deploy_mysql.deploy_mysql_name
  wordpress-deb = var.wordpress-deb 
  frontend = var.frontend 
  wordpress-port = var.wordpress-port
  replicas = var.replicas 
  wordpress-image = var.wordpress-image
  secret_name = module.module_secret.secret_name 
  volume_claim_name = module.module_pvc.volume_claim_name
}
