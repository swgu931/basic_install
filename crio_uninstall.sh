#!/bin/bash

sudo systemctl stop crio
sudo systemctl disable crio
sudo systemctl status crio
sudo apt purge -y cri-o cri-o-runc
sudo apt purge -y cri-tools


