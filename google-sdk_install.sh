echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt-get install apt-transport-https ca-certificates gnupg
 #참고: 배포판에서 서명 옵션을 지원하지 않는 경우 대신 이 명령어를 실행하세요.
 #echo "deb https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
 # 참고: 배포판의 apt-key 명령어가 --keyring 인수를 지원하지 않는 경우 대신 이 명령어를 실행하세요.
 # curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo apt-get update && sudo apt-get install google-cloud-sdk

# sudo apt-get install google-cloud-sdk-app-engine-python
# sudo apt-get install google-cloud-sdk-app-engine-python-extras
# sudo apt-get install google-cloud-sdk-app-engine-java
# sudo apt-get install google-cloud-sdk-app-engine-go
# sudo apt-get install google-cloud-sdk-bigtable-emulator
# sudo apt-get install google-cloud-sdk-cbt
# sudo apt-get install google-cloud-sdk-cloud-build-local
# sudo apt-get install google-cloud-sdk-datalab
# sudo apt-get install google-cloud-sdk-datastore-emulator
# sudo apt-get install google-cloud-sdk-firestore-emulator
# sudo apt-get install google-cloud-sdk-pubsub-emulator
# sudo apt-get install kubectl

