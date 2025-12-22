# howto Uninstall
# https://docs.ros.org/en/jazzy/Installation/Ubuntu-Install-Debs.html#ubuntu-deb-packages

sudo apt remove ~nros-jazzy-* && sudo apt autoremove

sudo apt remove ros2-apt-source
sudo apt update
sudo apt autoremove
sudo apt upgrade # Consider upgrading for packages previously shadowed.
