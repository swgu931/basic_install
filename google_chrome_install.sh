#!/bin/bash

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

sudo apt-get update -y 
sudo apt-get install -y google-chrome-stable
#sudo rm -rf /etc/apt/sources.list.d/google.list
#sudo rm -rf /etc/apt/sources.list.d/google-chrome.list
