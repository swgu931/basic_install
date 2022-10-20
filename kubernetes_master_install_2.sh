# https://computingforgeeks.com/deploy-kubernetes-cluster-on-ubuntu-with-kubeadm/
# https://www.itzgeek.com/how-tos/linux/ubuntu-how-tos/install-cri-o-on-ubuntu-22-04.html

sudo hostnamectl set-hostname kube-master-xxx(선택사항)
sudo vi /etc/hosts
   192.168.0.X    kube-master-xxx(host name)추가(host의 ip주소)

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF
 
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
 
sudo sysctl --system


sudo swapoff -a
sudo vi /etc/fstab
  swap으로 시작하는줄 주석처리

sudo modprobe overlay
sudo modprobe br_netfilter

sudo rm -rf /etc/cni/net.d/*

sudo apt update -y
sudo apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
 
export OS_VERSION=xUbuntu_20.04
export CRIO_VERSION=1.23

curl -fsSL https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS_VERSION/Release.key | sudo gpg --dearmor -o /usr/share/keyrings/libcontainers-archive-keyring.gpg
curl -fsSL https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$CRIO_VERSION/$OS_VERSION/Release.key | sudo gpg --dearmor -o /usr/share/keyrings/libcontainers-crio-archive-keyring.gpg
 
echo "deb [signed-by=/usr/share/keyrings/libcontainers-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS_VERSION/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
echo "deb [signed-by=/usr/share/keyrings/libcontainers-crio-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$CRIO_VERSION/$OS_VERSION/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$CRIO_VERSION.list
 
sudo apt update -y
sudo apt install -y cri-o cri-o-runc

# Update CRI-O CIDR subnet
cat << EOF | sudo tee /etc/cni/net.d/11-crio-ipv4-bridge.conf
{
    "cniVersion": "0.3.1",
    "name": "crio",
    "type": "bridge",
    "bridge": "cni0",
    "isGateway": true,
    "ipMasq": true,
    "hairpinMode": true,
    "ipam": {
        "type": "host-local",
        "routes": [
            { "dst": "0.0.0.0/0" }
        ],
        "ranges": [
            [{ "subnet": "10.85.0.0/16" }]
        ]
    }
}
EOF
 
sudo systemctl daemon-reload
sudo systemctl enable crio
sudo systemctl start crio
 
sudo systemctl status crio

#sudo apt install -y containernetworking-plugins
sudo systemctl restart crio
sudo apt install -y cri-tools
sudo crictl --runtime-endpoint unix:///var/run/crio/crio.sock version
sudo crictl info


sudo apt update -y
sudo apt install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list


sudo apt update -y 
sudo apt install -y kubelet=1.24.3-00 kubeadm=1.24.3-00 kubectl=1.24.3-00
sudo apt-mark hold kubelet kubeadm kubectl

sudo kubeadm init --cri-socket /var/run/crio/crio.sock


mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


kubectl get node

# to use master node as worker node 
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
kubectl taint nodes --all node-role.kubernetes.io/master-


cat << EOF | tee ros-demo.yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ros-talker-deployment
  labels:
    app: ros-talker
spec:
  replicas: 2
  selector:
    matchLabels:
      app: ros-talker
  template:
    metadata:
      labels:
        app: ros-talker
      annotations:
        k8s.v1.cni.cncf.io/networks: macvlan-conf
    spec:
      containers:
      - name: talker
        image: ros:foxy
        command: ["/bin/bash", "-c"]
        args: ["source /opt/ros/foxy/setup.bash && apt update && apt install -y curl && curl https://raw.githubusercontent.com/canonical/robotics-blog-k8s/main/publisher.py > publisher.py && /bin/python3 publisher.py talker"]
 
---
 
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ros-listener-deployment
  labels:
    app: ros-listener
  annotations:
    k8s.v1.cni.cncf.io/networks: macvlan-conf
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ros-listener
  template:
    metadata:
      labels:
        app: ros-listener
      annotations:
        k8s.v1.cni.cncf.io/networks: macvlan-conf
    spec:
      containers:
      - name: listener
        image: ros:foxy
        command: ["/bin/bash", "-c"]
        args: ["source /opt/ros/foxy/setup.bash && apt update && apt install -y curl && curl https://raw.githubusercontent.com/canonical/robotics-blog-k8s/main/subscriber.py > subscriber.py && /bin/python3 subscriber.py listener"]
---
EOF

kubectl apply -f ros-demo.yaml


