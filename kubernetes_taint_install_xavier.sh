#  Xavier 의 경우 : ubuntun20.04 
#  kubernetes version: 1.24.3
#  CRI-O version : 1.22 

#1)
sudo hostnamectl set-hostname kube-selfbalancing-robot
sudo rdate -p time.bora.net

exec bash
#2)
sudo vi /etc/hosts
  192.168.1.X  kube-selfbalancing-robot worker-1

exec bash

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
sudo swapoff -a
sudo vi /etc/fstab
   swap 으로 시작하는 줄 주석처리 (실행되지 않도록)

#6) br_netfilter 로딩 및 확인
sudo modprobe overlay
sudo modprobe br_netfilter
lsmod | grep br_netfilter

#7)
sudo rm -rf /etc/cni/net.d/*

#8) cri-o install

sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
 
export OS_VERSION=xUbuntu_20.04
export CRIO_VERSION=1.22
 
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


#9) container plugin 확인

ls /opt/cni/bin  에 아래 plugin 있는지 확인 없으면, 다음 #10)을 실행하고, 있으면 skip
   bridge  
   host-local

#10) container plugin install
sudo apt install -y containernetworking-plugins
sudo systemctl restart crio
 

#11) cri-tools install
sudo apt install -y cri-tools
sudo crictl --runtime-endpoint unix:///var/run/crio/crio.sock version


#12) sudo crictl info
   #다음 처럼 출력이 되어야 함 (RuntimeReady, NetworkReady 가 되면 Kubernetes 설치 준비가 끝남)
---
{
  "status": {
    "conditions": [
      {
        "type": "RuntimeReady",
        "status": true,
        "reason": "",
        "message": ""
      },
      {
        "type": "NetworkReady",
        "status": true,
        "reason": "",
        "message": ""
      }
    ]
  }
---


#13) kubernetes install

sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
sudo apt install -y kubelet=1.24.3-00 kubeadm=1.24.3-00 kubectl=1.24.3-00
sudo apt-mark hold kubelet kubeadm kubectl

sudo systemctl daemon-reload
sudo systemctl enable --now kubelet

#14) kubernetes bringup
sudo kubeadm reset --cri-socket /var/run/crio/crio.sock
sudo kubeadm init --cri-socket /var/run/crio/crio.sock

#15) 환경 세팅
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
 
#16) kubectl 명령어 확인

kubectl get nodes -A

kubectl get pods -A

kubectl describe nodes kube-selfbalancing-robot

#17) master node 도 worker node 로 스케쥴링되도록 (kubectl taint nodes --all key-)

kubectl taint nodes --all node-role.kubernetes.io/control-plane-
kubectl taint nodes --all node-role.kubernetes.io/master-

#18) pod 배치 테스트

kubectl run nginx --image=nginx:latest

kubectl get pod 

#-end-
