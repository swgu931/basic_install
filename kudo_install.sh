#!/bin/bash

OS=$(uname | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
wget -O kubectl-kudo https://github.com/kudobuilder/kudo/releases/download/v0.19.0/kubectl-kudo_0.19.0_${OS}_${ARCH}

chmod +x kubectl-kudo
sudo mv kubectl-kudo /usr/local/bin/kubectl-kudo
kubectl kudo --version


kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.8.0/cert-manager.yaml

kubectl get pods --namespace cert-manager

kubectl kudo init

kubectl kudo install Ch07_04-kudo-operator/

kubectl kudo get operators

kubectl kudo get instances

kubectl kudo get all ‒o yaml

kubectl get all

kubectl get deploy ‒o yaml

kubectl kudo upgrade Ch07_04-kudo-operator/ --instance test-instance

kubectl kudo get all ‒o yaml

kubectl get all
