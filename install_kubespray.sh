#!/bin/bash

# Variables

IP_HAPROXY=$(dig +short autohaproxy)
IP_MASTER=$(dig +short autok8smaster)
IP_NODE=$(dig +short autok8snode)


# Functions

prepare_kubespray(){

echo
echo "## 1. Git clone kubepsray"
git clone https://github.com/kubernetes-sigs/kubespray.git


echo
echo "## 2. Install requirements"
pip3 install --quiet -r kubespray/requirements.txt

echo
echo "## 3. ANSIBLE | copy sample inventory"
cp -rfp kubespray/inventory/sample kubespray/inventory/mykub

echo
echo "## 4. ANSIBLE | change inventory"
cat /etc/hosts | grep master | awk '{print $2" ansible_host="$1" ip="$1" etcd_member_name=etcd"NR}'>kubespray/inventory/mykub/inventory.ini
cat /etc/hosts | grep node | awk '{print $2" ansible_host="$1" ip="$1}'>>kubespray/inventory/mykub/inventory.ini

echo "[kube-master]">>kubespray/inventory/mykub/inventory.ini
cat /etc/hosts | grep master | awk '{print $2}'>>kubespray/inventory/mykub/inventory.ini

echo "[etcd]">>kubespray/inventory/mykub/inventory.ini
cat /etc/hosts | grep master | awk '{print $2}'>>kubespray/inventory/mykub/inventory.ini

echo "[kube-node]">>kubespray/inventory/mykub/inventory.ini
cat /etc/hosts | grep node | awk '{print $2}'>>kubespray/inventory/mykub/inventory.ini

echo "[calico-rr]">>kubespray/inventory/mykub/inventory.ini
echo "[k8s-cluster:children]">>kubespray/inventory/mykub/inventory.ini
echo "kube-master">>kubespray/inventory/mykub/inventory.ini
echo "kube-node">>kubespray/inventory/mykub/inventory.ini
echo "calico-rr">>kubespray/inventory/mykub/inventory.ini



echo
echo "## 5.x ANSIBLE | active external LB"
sed -i s/"## apiserver_loadbalancer_domain_name: \"elb.some.domain\""/"apiserver_loadbalancer_domain_name: \"autoelb.kub\""/g kubespray/inventory/mykub/group_vars/all/all.yml
sed -i s/"# loadbalancer_apiserver:"/"loadbalancer_apiserver:"/g kubespray/inventory/mykub/group_vars/all/all.yml
sed -i s/"#   address: 1.2.3.4"/"  address: ${IP_HAPROXY}"/g kubespray/inventory/mykub/group_vars/all/all.yml
sed -i s/"#   port: 1234"/"  port: 6443"/g kubespray/inventory/mykub/group_vars/all/all.yml
}


run_kubespray(){
echo
echo "## 7. ANSIBLE | Run kubepsray"
bash -c "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i kubespray/inventory/mykub/inventory.ini -b kubespray/cluster.yml"
}

install_kubectl(){
echo
echo "## 8. KUBECTL | Install"
apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
apt-get update -qq 2>&1 >/dev/null
apt-get install -qq -y kubectl 2>&1 >/dev/null
mkdir -p /root/.kube
echo
echo "## 9. KUBECTL | copy cert"
ssh -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa ${IP_KMASTER} "sudo cat /etc/kubernetes/admin.conf" >/root/.kube/config
}



# Lancement

prepare_kubespray
create_ssh_for_kubespray
run_kubespray
install_kubectl
