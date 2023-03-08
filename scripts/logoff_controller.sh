#!/bin/bash
options="poweroff\nreboot"
choice=$( echo -e $options | rofi -dmenu -l 3 -p "action")
exec systemctl $choice
