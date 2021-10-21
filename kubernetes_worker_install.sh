# kubernetes worker install

# Step 1 : master, worker1, worker2 공통

sudo swapoff -a && sudo sed -i '/swap/s/^/#/' /etc/fstab

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

sudo ufw disable

sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo apt update -y
sudo apt install -y apt-transport-https ca-certificates curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
#sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
#echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update -y
sudo apt install -y kubelet kubeadm kubectl kubernetes-cni

#sudo apt-mark hold kubelet kubeadm kubectl

sudo systemctl start kubelet
sudo systemctl enable kubelet

kubeadm version
kubelet --version
kubectl version

sudo cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo systemctl daemon-reload
sudo systemctl restart docker


# Step2: worker1, worker2, ...

echo "kubeadm join 10.0.2.100:6443 --token {token_from_master} --discovery-token-ca-cert-hash ${hash_from_master}"
## kubeadm --print-join-command @master

echo 'source <(kubectl completion bash)' >>~/.bashrc

echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -F __start_kubectl k' >>~/.bashrc

echo "Successfully done for worker"

