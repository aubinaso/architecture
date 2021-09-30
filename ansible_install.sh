#!/bin/bash


# installer Ansible

sudo apt update
sudo apt upgrade
sudo apt install -y python3-pip
sudo pip3 install -y ansible==2.10

# installer Terraform

sudo apt update
sudo apt upgrade
sudo apt install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt install terraform

