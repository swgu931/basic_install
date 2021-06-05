#!/bin/bash

dpkg --get-selections | grep -v deinstall | grep opencv
sudo apt-get --purge remove libopencv*
