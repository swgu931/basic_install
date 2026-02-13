# howto setup wifi network with command line interface


## 1. 무선 인터페이스 확인:
nmcli dev status

## 2. 사용 가능한 무선 네트워크 스캔:
nmcli dev wifi

## 3. 네트워크 연결 (WPA/WPA2 암호화):
nmcli dev wifi connect [SSID] password [PASSWORD] ifname wlan0

example: nmcli dev wifi connect MyWiFiNetwork password MyWiFiPassword ifname wlan0

## 4. 연결 확인:
nmcli con show

## 5. IP 주소 확인:
ip addr show wlan0


## 자동 연결 설정: 부팅 시 자동으로 무선 네트워크에 연결되도록 설정하려면, autoconnect 옵션을 사용합니다.
nmcli con modify "[connection_name]" autoconnect yes


## 숨겨진 SSID 연결: SSID가 숨겨진 AP에 연결하려면, hidden 옵션을 사용합니다.

nmcli dev wifi connect [SSID] password [PASSWORD] hidden yes ifname wlan0


## 문제 해결: 연결에 실패하는 경우, AP 이름과 비밀번호를 다시 확인하고, 무선 인터페이스가 활성화되어 있는지 확인하십시오. 
## 또한, 네트워크 관리자 로그를 확인하여 문제의 원인을 파악할 수 있습니다.

journalctl -u NetworkManager

