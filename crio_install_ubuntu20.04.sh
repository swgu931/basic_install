#!/bin/bash

sudo rm  /usr/share/keyrings/libcontainers-*
sudo rm  /etc/apt/sources.list.d/sudo rm devel:*

export OS_VERSION=xUbuntu_20.04
export CRIO_VERSION=1.23

curl -fsSL https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS_VERSION/Release.key | sudo gpg --dearmor -o /usr/share/keyrings/libcontainers-archive-keyring.gpg
curl -fsSL https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$CRIO_VERSION/$OS_VERSION/Release.key | sudo gpg --dearmor -o /usr/share/keyrings/libcontainers-crio-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/libcontainers-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS_VERSION/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
echo "deb [signed-by=/usr/share/keyrings/libcontainers-crio-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$CRIO_VERSION/$OS_VERSION/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$CRIO_VERSION.list

sudo apt update
sudo apt install -y cri-o cri-o-runc

sudo systemctl daemon-reload
sudo systemctl enable crio
sudo systemctl start crio
sudo systemctl status crio

# ls /opt/cni/bin
# bridge, host-local 등 plugin 이 없으면 containernetworking-plugin 설치해야 함.
# sudo apt install -y containernetworking-plugins
# sudo systemctl restart crio

sudo apt install -y cri-tools
sudo crictl --runtime-endpoint unix:///var/run/crio/crio.sock version
sudo crictl info

