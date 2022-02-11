# install docker
#!/bin/bash

sudo apt-get update -y 
sudo apt-get install -y \
apt-transport-https \
ca-certificates \
curl \
gnupg-agent \
software-properties-common


# Setup Repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


sudo apt-get update -y 
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

sudo docker run hello-world   


#if you have problem to login into docker hub
#출처: https://sukill.tistory.com/100 [sukill 의 블로그]
#sudo apt remove golang-docker-credential-helpers

sudo usermod -a -G docker ${USER}

echo "done sucessfully"

