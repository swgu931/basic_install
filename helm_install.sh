#!/bin/bash


curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

#curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash


#helm plugin install https://github.com/databus23/helm-diff
#helm plugin install https://github.com/jkroepke/helm-secrets --version v3.12.0


# Repository add/remove
#helm repo add bitnami https://charts.bitnami.com/bitnami
#helm repo list

# Repository chart search
#helm search repo
#helm search repo mariadb

# chart info 
#helm show chart bitnami/mariadb
#helm inspect values bitnami/mariadb

# chart archive install
#helm install add-db bitnami/mariadb
#helm install app-db --set auth.rootPassword=secretpassword,auth.database=app_database bitnami/mariadb
#helm list

# chart archive uninstall
#helm uninstall add-db


# exercise

#helm repo add bitnami https://charts.bitnami.com/bitnami
#helm repo list
#helm search repo bitnami/nginx
#helm install ckad-webserver bitnami/nginx
#helm list
#kubectl get all
#helm uninstall ckad-webserver
