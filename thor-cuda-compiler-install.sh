# howto install nvcc compiler for cuda-13.0 on NVIDIA AGX Thor
## -https://developer.nvidia.com/cuda-13-0-0-download-archive?target_os=Linux&target_arch=arm64-sbsa&Compilation=Native&Distribution=Ubuntu&target_version=24.04&target_type=deb_local


## CUDA Toolkit Installer

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/sbsa/cuda-ubuntu2404.pin
sudo mv cuda-ubuntu2404.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/13.0.0/local_installers/cuda-repo-ubuntu2404-13-0-local_13.0.0-580.65.06-1_arm64.deb
sudo dpkg -i cuda-repo-ubuntu2404-13-0-local_13.0.0-580.65.06-1_arm64.deb
sudo cp /var/cuda-repo-ubuntu2404-13-0-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda-toolkit-13-0


## Driver Installer

sudo apt-get install -y cuda-drivers


## ls -d /usr/local/cuda-13.0
export PATH=/usr/local/cuda-13.0/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-13.0/lib64:$LD_LIBRARY_PATH
export CUDA_HOME=/usr/local/cuda-13.0

nvcc --version

find /usr/local/cuda-13.0 -name libcudart.so*


