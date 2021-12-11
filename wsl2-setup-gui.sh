#!/bin/bash


# Install VcXsrv Widows X Server in widows host

sudo apt-get install dbus-x11 gnome-terminal
export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0.0 >> ~/.bashrc
export XDG_RUNTIME_DIR=/tmp/XDG_RUNTIME_DIR


