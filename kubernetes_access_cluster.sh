# Accessing the Cluster from dev machine


curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client --short

# scp master:~/.kube/config ./kubeconfig
# sed -i "s/10.240.0.10/${EXTERNAL_ADDRESS}/" kubeconfig
# mv -i ./kubeconfig $HOME/.kube/config


#echo 'source <(kubectl completion bash)' >>~/.bashrc

#echo 'alias k=kubectl' >>~/.bashrc
#echo 'complete -F __start_kubectl k' >>~/.bashrc

# command 
# kubectl config current-context
# kubectl config use-context user@kubernetes
# kubectl config set-context --current --namespace=my-ns
