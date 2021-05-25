#!/bin/bash

#ref: https://askubuntu.com/questions/1228614/installing-citrix-receiver-on-ubuntu-20-04-missing-libwebkitgtk-1-0-0

cd /opt/Citrix/ICAClient/keystore
sudo rm -r cacerts
sudo ln -s /etc/ssl/certs cacerts
