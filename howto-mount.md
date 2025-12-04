# how to mount sd card

sudo fdisk -l

sudo file -s /dev/sdX

sudo mkdir -p /mnt/sdcard
sudo mount /dev/sdX1 /mnt/sdcard

df -h

sudo umount /mnt/sdcard


*자동 마운트 설정 (선택 사항)

sudo vi /etc/fstab
      /dev/sdX1  /mnt/sdcard  auto  defaults  0  0

바로 적용
sudo mount -a
