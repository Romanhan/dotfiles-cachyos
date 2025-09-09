#!/usr/bin/env bash
# Simple update checker and installer for Waybar

TERMINAL="kitty"

# Check for updates
check_updates() {
  # Count official updates
  official_updates=$(checkupdates 2>/dev/null | wc -l)

  # Count AUR updates
  aur_updates=$(yay -Qua 2>/dev/null | wc -l)

  # Count Flatpak updates (if installed)
  flatpak_updates=0
  if command -v flatpak >/dev/null 2>&1; then
    flatpak_updates=$(flatpak remote-ls --updates 2>/dev/null | wc -l)
  fi

  # Total updates
  total_updates=$((official_updates + aur_updates + flatpak_updates))

  # Build output
  if [[ $total_updates -eq 0 ]]; then
    echo '{"text": "", "tooltip": "System is up to date"}'
  else
    tooltip="Updates available:\\nOfficial: $official_updates\\nAUR: $aur_updates"
    if command -v flatpak >/dev/null 2>&1; then
      tooltip+="\\nFlatpak: $flatpak_updates"
    fi
    echo "{\"text\":\"󰅢 $total_updates\",\"tooltip\":\"$tooltip\"}"
  fi
}

# Perform updates when clicked
perform_updates() {
  # Build update command
  update_cmd="yay -Syu --noconfirm"

  # Add flatpak if installed
  if command -v flatpak >/dev/null 2>&1; then
    update_cmd="$update_cmd && echo && echo 'Updating Flatpak...' && flatpak update -y"
  fi

  # Run in terminal
  $TERMINAL -e bash -c "$update_cmd && echo 'Updates complete! Press any key to exit...' && read -n 1"
}

# Main logic
if [[ "$1" == "update" ]]; then
  perform_updates
else
  check_updates
fi
