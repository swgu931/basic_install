#!/bin/bash


# 1. Install Multus
## ref: https://ubuntu.com/blog/multus-how-to-escape-the-kubernetes-eth0-prison

git clone https://github.com/intel/multus-cni.git
cd multus-cni/
cat ./images/multus-daemonset.yml | kubectl apply -f -

# validate installation
kubectl get pods --all-namespaces | grep -i multus


# 2. Install macvlan 
## spec.config.master는 machine의 network interface로 한다.
## ref: https://hicu.be/docker-networking-macvlan-bridge-mode-configuration

cat <<EOF | kubectl create -f -
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: macvlan-conf
spec:
  config: '{
      "cniVersion": "0.3.0",
      "type": "macvlan",
      # your master's network interface
      "master": "eth0",
      "mode": "bridge",
      "isDefaultgateway": true,
      "ipam": {
        "type": "host-local",
        "subnet": "192.168.1.0/24",
        "rangeStart": "192.168.1.200",
        "rangeEnd": "192.168.1.216",
        "routes": [
          { "dst": "0.0.0.0/0" }
        ],
        "gateway": "192.168.1.1"
      }
    }'
EOF

# 3. check macvlan-conf
kubectl get network-attachment-definitions
kubectl describe network-attachment-definitions macvlan-conf
