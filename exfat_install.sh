#!/bin/bash

sudo apt-get install exfat-fuse exfat-utils

# sdxx로 되어있는 부분은 gparted를 통해 외장하드의 정보를 알아본 뒤 치환한다.
#sudo mkdir /media/exfat
#sudo mount -t exfat /dev/sdxx /media/exfat
