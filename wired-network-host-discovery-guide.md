# 유선 네트워크 호스트 검색 가이드

현재 유선 네트워크에 연결된 장치들을 검색하는 방법입니다.

현재 확인된 유선 인터페이스는 다음과 같습니다.

- 인터페이스: `enx00e04cffc76c`
- 로컬 IP: `192.168.1.100/24`
- 네트워크: `192.168.1.0/24`
- 게이트웨이: `192.168.1.1`

> 시스템마다 인터페이스 이름과 네트워크 대역이 다를 수 있습니다. 아래 명령에서 `enx00e04cffc76c`와 `192.168.1.0/24`를 자신의 환경에 맞게 바꾸세요.

## 1. 유선 인터페이스와 IP 확인

```bash
ip -brief link
ip -brief addr
```

특정 인터페이스 확인:

```bash
ip addr show dev enx00e04cffc76c
```

예상 결과:

```text
inet 192.168.1.100/24
```

`/24` 네트워크의 일반적인 검색 범위는 다음과 같습니다.

```text
192.168.1.0/24
```

## 2. 기본 게이트웨이와 라우팅 확인

```bash
ip route
```

유선 인터페이스의 경로만 확인:

```bash
ip route show dev enx00e04cffc76c
```

예:

```text
192.168.1.0/24 dev enx00e04cffc76c
 default via 192.168.1.1 dev enx00e04cffc76c
```

## 3. 권장 방법: arp-scan

같은 로컬 유선 네트워크의 장치를 찾을 때는 ARP 검색이 가장 적합합니다.

### 설치

Ubuntu/Debian:

```bash
sudo apt update
sudo apt install arp-scan
```

Fedora:

```bash
sudo dnf install arp-scan
```

Arch Linux:

```bash
sudo pacman -S arp-scan
```

### 네트워크 검색

```bash
sudo arp-scan --interface=enx00e04cffc76c --localnet
```

네트워크를 직접 지정할 수도 있습니다.

```bash
sudo arp-scan --interface=enx00e04cffc76c 192.168.1.0/24
```

결과 예:

```text
192.168.1.1     aa:bb:cc:dd:ee:ff   Vendor name
192.168.1.20    11:22:33:44:55:66   Vendor name
192.168.1.100   00:e0:4c:ff:c7:6c   Realtek
```

각 열의 의미:

```text
IP 주소        MAC 주소              제조사
```

## 4. nmap으로 호스트 검색

### 설치

Ubuntu/Debian:

```bash
sudo apt update
sudo apt install nmap
```

### 호스트 검색

```bash
sudo nmap -sn -e enx00e04cffc76c 192.168.1.0/24
```

- `-sn`: 포트 스캔 없이 살아 있는 호스트만 검색
- `-e`: 사용할 네트워크 인터페이스 지정

로컬 이더넷에서 ARP 검색을 명시하려면:

```bash
sudo nmap -sn -PR -e enx00e04cffc76c 192.168.1.0/24
```

특정 장치의 서비스와 버전 확인:

```bash
sudo nmap -sV 192.168.1.20
```

네트워크 전체의 서비스 확인:

```bash
sudo nmap -sV 192.168.1.0/24
```

> 네트워크 전체 포트 스캔은 시간이 걸릴 수 있고, 관리 권한이 없는 네트워크에서는 실행하지 마세요.

## 5. ping으로 간단히 검색

별도 패키지 설치 없이 검색할 수 있지만, ping을 차단하는 장치는 찾지 못할 수 있습니다.

```bash
for i in $(seq 1 254); do
    ping -c 1 -W 1 192.168.1.$i >/dev/null 2>&1 && \
    echo "192.168.1.$i is alive"
done
```

유선 인터페이스를 명시하려면:

```bash
for i in $(seq 1 254); do
    ping -I enx00e04cffc76c -c 1 -W 1 192.168.1.$i >/dev/null 2>&1 && \
    echo "192.168.1.$i is alive"
done
```

## 6. ARP 캐시 확인

검색 후 운영체제가 발견한 장치는 다음 명령으로 확인할 수 있습니다.

```bash
ip neigh show dev enx00e04cffc76c
```

정상적으로 발견된 장치의 예:

```text
192.168.1.1 dev enx00e04cffc76c lladdr aa:bb:cc:dd:ee:ff REACHABLE
```

상태 의미:

- `REACHABLE`: 현재 접근 가능
- `STALE`: 정보는 있지만 최근 사용되지 않음
- `FAILED`: ARP 응답 없음
- `INCOMPLETE`: 응답 대기 중

## 7. 결과가 없을 때 점검

### 인터페이스 상태 확인

```bash
cat /sys/class/net/enx00e04cffc76c/operstate
```

정상적인 결과:

```text
up
```

### 케이블 링크 확인

먼저 `ethtool` 설치 여부를 확인하고 실행합니다.

```bash
sudo ethtool enx00e04cffc76c
```

다음 항목을 확인하세요.

```text
Link detected: yes
```

### 송수신 패킷 통계 확인

```bash
ip -s link show dev enx00e04cffc76c
```

### ARP 패킷 실시간 확인

터미널 하나에서 다음 명령을 실행합니다.

```bash
sudo tcpdump -ni enx00e04cffc76c arp
```

그 상태에서 다른 터미널에서 검색합니다.

```bash
sudo arp-scan --interface=enx00e04cffc76c 192.168.1.0/24
```

ARP 요청과 응답이 보이는지 확인합니다.

## 8. 가장 간단한 전체 절차

현재 환경에서는 다음 순서로 실행하면 됩니다.

```bash
ip -brief addr show dev enx00e04cffc76c
ip route show dev enx00e04cffc76c
sudo apt update
sudo apt install arp-scan
sudo arp-scan --interface=enx00e04cffc76c 192.168.1.0/24
ip neigh show dev enx00e04cffc76c
```

## 9. 아무 장치도 발견되지 않을 때

ARP 응답이 전혀 없다면 다음 원인을 확인하세요.

- 이더넷 케이블이 제대로 연결되지 않음
- 스위치나 공유기의 포트가 비활성화됨
- USB 이더넷 어댑터 문제
- VLAN 또는 네트워크 격리 설정
- 현재 IP 대역이 실제 네트워크 대역과 다름
- 다른 장치가 꺼져 있거나 ARP 응답을 차단함
- 네트워크에 DHCP나 게이트웨이가 없음

현재 설정에서는 `192.168.1.100`이 이 컴퓨터의 주소이며, `192.168.1.1` 게이트웨이와 다른 장치들이 응답하지 않는 경우 위 항목들을 점검해야 합니다.

