#!/bin/bash
# ROS2 foxy debian package install


#Set locale
locale  # check for UTF-8

sudo apt update -y && sudo apt install locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

locale  # verify settings


#Setup Sources

sudo apt update -y && sudo apt install -y curl gnupg2 lsb-release
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

#Install ROS 2 packages

sudo apt update -y
sudo apt install -y ros-foxy-desktop

#Sourcing the setup script
source /opt/ros/foxy/setup.bash


#Install argcomplete (optional)

sudo apt install -y python3-pip
pip3 install -U argcomplete
