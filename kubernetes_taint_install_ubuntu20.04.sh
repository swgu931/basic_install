#  OS : ubuntun20.04 
#  kubernetes version: 1.24.3
#  container runtime : 1.22 

#1)
read -t 10 -p "please input hostname you want : " HOSTNAME

echo "You typed \"$HOSTNAME\", proceed in 10sec,  if you don't want, exit with ctrl+c"
sleep 10


sudo hostnamectl set-hostname $HOSTNAME
sudo rdate -p time.bora.net

exec bash
#2)
# sudo vi /etc/hosts
#   192.168.1.X  kube-selfbalancing-robot worker-1

# exec bash

#3)
sudo apt install ufw
sudo ufw disable  

#4)
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF
 
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

#5)
sudo swapoff -a && sudo sed -i '/swap/s/^/#/' /etc/fstab
# sudo swapoff -a
# sudo vi /etc/fstab
#    swap 으로 시작하는 줄 주석처리 (실행되지 않도록)

#6) br_netfilter 로딩 및 확인
sudo modprobe overlay
sudo modprobe br_netfilter
lsmod | grep br_netfilter

#7)
sudo rm -rf /etc/cni/net.d/*

#8) 수정필요
sudo apt -y install containerd.io
sudo containerd config default | tee /etc/containerd/config.toml
sudo cp /etc/containerd/config.toml /etc/containerd/config.toml.save
sudo sed 's/cri//g' /etc/containerd/config.toml.save > /etc/containerd/config.toml
# sudo vi /etc/containerd/config.toml
#     disabled_plugins = [""]		---> CRI 제거

sudo systemctl restart containerd.service
sudo systemctl status containerd.service

#9) kubernetes install

sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
sudo rm /usr/share/keyrings/kubernetes-archive-keyring.gpg
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
sudo apt install -y kubelet=1.24.3-00 kubeadm=1.24.3-00 kubectl=1.24.3-00
sudo apt-mark hold kubelet kubeadm kubectl

sudo systemctl daemon-reload
sudo systemctl enable --now kubelet

#10) kubernetes bringup
sudo kubeadm init --pod-network-cidr=10.96.0.0/12

#11) 환경 세팅
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
 
#12) kubectl 명령어 확인

kubectl get nodes -A

kubectl get pods -A

k get node -o jsonpath="{.items[0].status.addresses[0].address}"

#13) master node 도 worker node 로 스케쥴링되도록 (kubectl taint nodes --all key-)

kubectl taint nodes --all node-role.kubernetes.io/control-plane-
kubectl taint nodes --all node-role.kubernetes.io/master-

#14) pod 배치 테스트

kubectl run nginx --image=nginx:latest
kubectl get pod 




#-end-


## Check Point
# ls /etc/cni/net.d 
# vi /etc/fstab 
# ls /opt/cni/bin  에 아래 plugin 있는지 확인 없으면, 다음 #10)을 실행하고, 있으면 skip
#    bridge  
#    host-local
# lsmod | grep br_netfilter