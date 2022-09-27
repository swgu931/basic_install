#!/bin/bash



wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sudo apt update -y
sudo apt install google-chrome-stable -y
google-chrome --version


#sudo rm -rf /etc/apt/sources.list.d/google.list
#sudo rm -rf /etc/apt/sources.list.d/google-chrome.list
