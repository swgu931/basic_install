# docker uninstall
#!/bin/bash

sudo apt-get purge -y docker-ce
sudo apt-get autoremove --purge -y docker-engine
sudo rm -rf /var/lib/docker
sudo groupdel docker
sudo rm -rf /var/run/docker.sock
sudo rm -rf /etc/docker
sudo rm -rf /usr/bin/docker
sudo rm -rf /etc/systemd/system/docker.service.d

sudo apt-get purge -y docker-engine
sudo apt-get purge -y docker-engine docker docker.io docker-ce  
sudo apt-get autoremove -y --purge docker-engine docker docker.io docker-ce  

echo "done sucessfully"
