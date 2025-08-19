#!/bin/bash

# Options for the power menu
options=" Reboot\n Shutdown\n󰗽 Logout\n󰍃 Lock Screen"

# Show rofi menu
selected=$(echo -e "$options" | rofi -dmenu -p "Power Menu" -i -theme ~/.config/rofi/powermenu.rasi)

# Handle the selected option
case $selected in
"󰍃 Lock Screen")
  hyprlock
  ;;
"󰗽 Logout")
  hyprctl dispatch exit
  ;;
" Reboot")
  systemctl reboot
  ;;
" Shutdown")
  systemctl poweroff
  ;;
esac
