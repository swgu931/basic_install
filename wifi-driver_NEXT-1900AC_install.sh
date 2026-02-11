# howto install NEXT-1900AC wifi card driver

sudo apt update
sudo apt install iw build-essential dkms libelf-dev linux-headers-$(uname -r)

git clone https://github.com/morrownr/8814au.git
cd 8814au
sudo ./install-driver.sh

