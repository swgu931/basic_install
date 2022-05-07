#!/bin/bash


curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

#curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash


helm plugin install https://github.com/databus23/helm-diff
helm plugin install https://github.com/jkroepke/helm-secrets --version v3.12.0

helm repo add bitnami https://charts.bitnami.com/bitnami
