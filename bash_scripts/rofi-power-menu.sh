#!/bin/bash

# options to be displayed
option0="lock"
option1="logout"
option2="suspend"
option3="reboot"
option4="shutdown"

# options passed into variable
options="\uf023   $option0\n\uf842   $option1\n\uf9b1 $option2\n\u21ba   $option3\n\uf011   $option4"
chosen="$(echo -e "$options" | rofi -lines 5 -location 0 -theme-str 'window {width: 10%;} listview {lines: 5;}' -dmenu -p "Power")"
choice="$(echo $chosen | head -n1 | awk  '{print $2;}')"

case $choice in
    $option0)
        betterlockscreen -l;;
    $option1)
        loginctl terminate-session ${XDG_SESSION_ID-};;
    $option2)
        systemctl suspend;;
    $option3)
        systemctl reboot;;
	$option4)
        systemctl poweroff;;
esac
