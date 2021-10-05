# password
mysql-pass = "aubin"

# labels
wordpress-deb = "wp-wordpress"
frontend = "frontend"
mysql-lbl = "wp-mysql"

# port
wordpress-port = 80
wordpress-target-port = 80
node-ip-port = 80
wordpress-port-name = "port_name_wordpress"
mysql-port = 3306

# dir
pvpvc-dir = "html"
wordpress-dir = "/var/www/html"

# image
mysql-image = "mysql:5.6"
wordpress-image = "wordpress:latest"

# other
pvpvc-name = "persistant_volume"
pv-size = "10Gi"
server-nfs = "192.168.1.100"
pvpvc-type = "DirectoryOrCreate"
pvc-size = "10Gi"
replicas = 1
