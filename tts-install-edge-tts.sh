# 1. 시스템 패키지 목록 업데이트
sudo apt update

# 2. 파이썬 pip 관리자 설치 (Y/n 메시지가 나오면 엔터를 누르세요)
sudo apt install python3-pip -y

# 3. edge-tts 라이브러리 설치
pip3 install edge-tts



#edge-tts --list-voices | grep en- 

#edge-tts --voice en-US-BrianNeural --text "Hello. This is a very natural-sounding artificial intelligence voice running on Ubuntu twenty two point zero four." --write-media english_us.mp3


## 10%느리게

##edge-tts --voice en-US-BrianNeural --rate=-10% --text "Let me speak a bit slower and more clearly for you." --write-media slow.mp3

## 15%빠르게
##edge-tts --voice en-US-BrianNeural --rate=+15% --text "I can also speak a bit faster if you want to save time." --write-media fast.mp3

