# AP mode setting on RPi
- ref : ## https://github.com/PinkWink/for_ROS2_study
- [RPi5] 1-8. AP mode 셋팅으로 라즈베리파이보드를 공유기로 ...

```
khadas mini PC

ssh rpi@192.168.0.173

```
sudo apt update

sudo apt install dnsmasq hostapd

sudo vi /etc/hostapd/hostapd.conf

## https://github.com/PinkWink/for_ROS2_study
```
# 공유기 ssid
ssid=


# 공유기 패스워드
wpa_passphrase=
---


```

sudo vi /etc/default/hostapd

---
DAEMON_CONF="/etc/hostapd/hostapd.conf"
---

sudo systemctl unmask hostapd
sudo systemctl enable hostapd
```

```
sudo vi /etc/dnsmasq.conf
---
port=5353
interface=ap0
dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24H
---

sudo systemctl restart dnsmasq
```

sudo vi /etc/sysctl.conf
---
net.ipv4.ip_forward=1
---

sudo apt install iw

sudo iw dev wlan0 interface add ap0 type __ap
sudo ifconfig ap0 192.168.4.1/24 netmask 255.255.255.0
sudo ifconfig ap0 up
```

```
vi /etc/systemd/system/pw-ap-mode.service
---
[Unit]
Description=Minibot AP Network Setup
After=network.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c "/usr/bin/sudo /sbin/iw dev wlan0 interface add ap0 type __ap && \
    /bin/sleep 3 && \
    /usr/bin/sudo /sbin/ifconfig ap0 192.168.4.1/24 netmask 255.255.255.0 && \
    /usr/bin/sudo /sbin/ifconfig ap0 up && \
    /usr/bin/sudo /sbin/iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE"
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
---

sudo systemctl daemon-reload
sudo systemctl enable pw-ap-mode.service
```

```
vi ~/wifi_setup.sh
---
#!/bin/bash
read -p "Enter WiFi SSID: " wifi_ssid
read -p "Enter WiFi Password: " wifi_password
echo
if [ -z "$wifi_password" ]; then
    sudo nmcli device wifi connect "$wifi_ssid" ifname wlan0
else
    sudo nmcli device wifi connect "$wifi_ssid" password "$wifi_password" ifname wlan0
fi
if [ $? -eq 0 ]; then
    echo "Successfully connected to $wifi_ssid"
else
    echo "Failed to connect to $wifi_ssid"
fi
---

sudo chmod 777 wifi_setup.sh
```

## 다른 컴퓨터에서 wifi로 ap0에 접속

## ssh 접속을 아래와 같이
```
ssh pw@192.168.4.1

nmcli dev wifi list
nmcli device

# RPi 를 인터넷에 연결시키기 위해

./wifi_setup.sh

```

## 짜잔: RPi를 공유기로 해서 연결한 컴퓨터에서 인터넷이 되는 것 확인.

끝.
