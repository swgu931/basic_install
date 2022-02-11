# kubernetes install
## ref: https://opensource.com/article/20/6/kubernetes-raspberry-pi

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



sudo sed -i '$ s/$/ cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1 swapaccount=1/' /boot/firmware/cmdline.txt

#docker info again. The Cgroups driver is now systemd, and the warnings are gone.
docker info | grep Cgroup

sudo swapoff -a && sudo sed -i '/swap/s/^/#/' /etc/fstab

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

# Add the packages.cloud.google.com apt key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Add the Kubernetes repo
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

# Update the apt cache and install kubelet, kubeadm, and kubectl
sudo apt update -y && sudo apt install -y kubelet kubeadm kubectl --allow-change-held-packages 


# Disable (mark as held) updates for the Kubernetes packages
sudo apt-mark hold kubelet kubeadm kubectl
kubelet set on hold.
kubeadm set on hold.
kubectl set on hold.


#############################
# Create a Kubernetes cluster
TOKEN=$(sudo kubeadm token generate)
echo $TOKEN

# Initialize the Control Plane
sudo kubeadm init --token=${TOKEN} --pod-network-cidr=10.244.0.0/16


kubeadm version
kubelet --version
kubectl version


mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# if root user, export KUBECONFIG=/etc/kubernetes/admin.conf

## Single node cluster
kubectl taint nodes --all node-role.kubernetes.io/master-


#######################
# Install a CNI add-on
# Install weave for ROS2 multicast

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

######################
# Setup Environments in ~/.bashrc

echo 'source <(kubectl completion bash)' >>~/.bashrc

echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -F __start_kubectl k' >>~/.bashrc

source ~/.bashrc
echo "Successfully done"

