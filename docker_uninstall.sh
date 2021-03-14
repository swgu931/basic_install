# docker uninstall
#!/bin/bash

sudo apt-get purge docker-ce
sudo apt-get autoremove --purge docker-engine
sudo rm -rf /var/lib/docker
sudo groupdel docker
sudo rm -rf /var/run/docker.sock
sudo rm -rf /etc/docker
sudo rm -rf /usr/bin/docker

sudo apt-get purge docker-engine
sudo apt-get purge -y docker-engine docker docker.io docker-ce  
sudo apt-get autoremove -y --purge docker-engine docker docker.io docker-ce  

echo "done sucessfully"