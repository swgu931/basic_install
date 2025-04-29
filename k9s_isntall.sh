sudo wget https://github.com/derailed/k9s/releases/latest/download/k9s_linux_amd64.deb
sudo dpkg -i ./k9s_linux_amd64.deb
sudo rm k9s_linux_amd64.deb

vi ~/.profile
---
PATH=$PATH:/usr/bin
---
