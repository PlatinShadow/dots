#!/bin/bash

polybar-msg cmd quit

source "${HOME}/.cache/wal/colors.sh"

echo "---" | tee -a /tmp/polybar.log
polybar --config=$HOME/.config/polybar/config.ini epicbar 2>&1 | tee -a /tmp/polybar.log & disown 
echo "Polybar Launched!"


