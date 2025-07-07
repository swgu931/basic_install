#!/bin/bash

sudo apt install tmux


cat <<EOF > ~/.tmux-conf
set -g mouse on
EOF

tmux source-file ~/.tmux.conf

