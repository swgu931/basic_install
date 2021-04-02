#!/bin/bash

# basic install program 
# - Something after linux installed

sudo apt-get update -y
sudo apt-get install -y net-tools iputils-ping openssh-server wget apt-utils
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

sudo dpkg-reconfigure ca-certificates 

