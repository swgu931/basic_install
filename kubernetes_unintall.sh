#!/bin/bash

sudo kubeadm reset
sudo systemctl stop kubelet
dpkg --list | grep kube
sudo apt-get purge -y kubeadm kubectl kubelet kubernetes-cni
dpkg --list | grep kube
sudo rm -rf /etc/kubernetes
sudo rm -rf $HOME/.kube
sudo rm -rf /var/lib/etcd
sudo rm -rf /usr/local/bin/kubectl
sudo rm -rf /usr/bin/kubectl
sudo rm -rf /usr/local/bin/kubeadm
sudo rm -rf /usr/bin/kubeadm
sudo rm -rf /usr/local/bin/kubelet
sudo rm -rf /usr/bin/kubelet
sudo rm -rf /var/lib/kubelet
