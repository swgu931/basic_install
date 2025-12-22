# howto install ROS 2 Jazzy
# https://docs.ros.org/en/jazzy/Installation/Ubuntu-Install-Debs.html#ubuntu-deb-packages

locale  # check for UTF-8

sudo apt update && sudo apt install locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

locale  # verify settings

sudo apt install software-properties-common
sudo add-apt-repository universe

sudo apt update && sudo apt install curl -y
export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}')
curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb"
sudo dpkg -i /tmp/ros2-apt-source.deb

sudo apt update && sudo apt install ros-dev-tools

# Install ROS 2
sudo apt update
sudo apt upgrade
sudo apt install ros-jazzy-desktop
sudo apt install ros-jazzy-ros-base

# Install additional RMW implementations (optional)

#The default middleware that ROS 2 uses is Fast DDS, but the middleware (RMW) can be replaced at runtime. See the guide on how to work with multiple RMWs.

# Setup environment
source /opt/ros/jazzy/setup.bash

# Try some examples
# If you installed ros-jazzy-desktop above you can try some examples.

# source /opt/ros/jazzy/setup.bash
# ros2 run demo_nodes_cpp talker

# source /opt/ros/jazzy/setup.bash
# ros2 run demo_nodes_py listener

