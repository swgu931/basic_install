# install docker
#!/bin/bash

sudo apt-get update -y 
sudo apt-get install -y \
apt-transport-https \
ca-certificates \
curl \
gnupg-agent \
software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update -y 
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo apt-get install pass gnupg2
gpg2 --gen-key
pass init $gpg_id
sudo docker run hello-world   


#if you have problem to login into docker hub
#출처: https://sukill.tistory.com/100 [sukill 의 블로그]
sudo apt remove golang-docker-credential-helpers

sudo usermod -a -G docker ${USER}

sudo apt-get install -y docker-compose

echo "done sucessfully"

