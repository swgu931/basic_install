#!/bin/bash

# Oracle virtualbox install on Ubuntu

echo deb http://download.virtualbox.org/virtualbox/debian xenial contrib >> /etc/apt/sources.list
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -

sudo apt-get update
sudo apt-get install -y linux-headers-$(uname -r) build-essential virtualbox dkms

VBoxManage --version
sudo service virtualbox status


# extension pack install

wget http://download.virtualbox.org/virtualbox/5.2.42/Oracle_VM_VirtualBox_Extension_Pack-5.2.42-137960.vbox-extpack
VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-5.2.42-137960.vbox-extpack
