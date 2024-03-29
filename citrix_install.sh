#!/bin/bash


# download from https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html
# manual from https://docs.citrix.com/en-us/citrix-workspace-app-for-linux/install.html#debian-packages

# ssl issue ref: https://askubuntu.com/questions/1228614/installing-citrix-receiver-on-ubuntu-20-04-missing-libwebkitgtk-1-0-0

cd /opt/Citrix/ICAClient/keystore
sudo rm -r cacerts
sudo ln -s /etc/ssl/certs cacerts
