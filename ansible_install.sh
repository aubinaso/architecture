#!/bin/bash

sudo apt install -y sshpass

sudo su - vagrant bash -c "ssh-keygen -b 2048 -t rsa -f /home/vagrant/.ssh/id_rsa -q -N ''"
sudo su - vagrant bash -c "eval `ssh-agent`"
sudo su - vagrant bash -c "ssh-add" 
for srv in $(cat /etc/hosts | grep auto | awk '{print $2}');do
	sudo su - vagrant bash -c "sshpass -p 'vagrant' ssh-copy-id -o StrictHostKeyChecking=no vagrant@$srv'
done

# installer Ansible

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y python3-pip
sudo bash -c "pip3 install -y ansible==2.10"

# installer Terraform

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

# installer Ansible

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y python3-pip
sudo bash -c "pip3 install -y ansible==2.10"

# installer Terraform

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

