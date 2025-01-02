# Install Guide for Gazebo @ Linux22.04
# Fortress binaries are provided for Ubuntu Bionic, Focal and Jammy. All of the Fortress binaries are hosted in the osrfoundation repository. To install all of them, the metapackage ignition-fortress can be installed.

#!/bin/bash

sudo apt-get update -y
sudo apt-get install lsb-release gnupg -y

sudo curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null
sudo apt-get update -y
sudo apt-get install ignition-fortress -y



# Uninstalling binary install
# sudo apt remove ignition-fortress && sudo apt autoremove


