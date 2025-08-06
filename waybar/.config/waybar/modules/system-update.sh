#!/usr/bin/env bash
#!/usr/bin/env bash
# Standalone script for checking and applying system updates
# Designed for Arch Linux with pacman; modify for other distros if needed

# Paths
LOCK_FILE="/tmp/system-update.lock"
TERMINAL="kitty" # Replace with your preferred terminal (e.g., kitty, gnome-terminal)

# Detect AUR helper
detect_aur_helper() {
  local helpers=("paru" "yay" "pikaur" "aurman")
  for helper in "${helpers[@]}"; do
    if command -v "$helper" >/dev/null 2>&1; then
      echo "$helper"
      return 0
    fi
  done
  echo ""
}

# Check if package is installed
pkg_installed() {
  command -v "$1" >/dev/null 2>&1 || pacman -Qi "$1" >/dev/null 2>&1
}

# Function to send notifications (optional, remove if not needed)
send_notification() {
  local urgency="$1"
  local message="$2"
  # Comment out the line below if you don't want notifications
  # notify-send -u "$urgency" "System Update" "$message"
}

# Function to check for updates
check_updates() {
  if [[ -f "$LOCK_FILE" ]]; then
    echo '{"text": "0", "tooltip": "Update check in progress"}'
    return 1
  fi

  touch "$LOCK_FILE"
  send_notification normal "Checking for system updates..."

  # Check for official updates
  if ! command -v checkupdates >/dev/null 2>&1; then
    send_notification critical "checkupdates not found. Install pacman-contrib."
    rm -f "$LOCK_FILE"
    echo '{"text": "❌", "tooltip": "Error: checkupdates not found"}'
    return 1
  fi

  # Count official updates
  local official_updates
  official_updates=$(checkupdates 2>/dev/null | wc -l)

  # Check for AUR updates
  local aur_updates=0
  local aur_helper
  aur_helper=$(detect_aur_helper)
  if [[ -n "$aur_helper" ]]; then
    case "$aur_helper" in
    paru)
      aur_updates=$(paru -Qua 2>/dev/null | wc -l)
      ;;
    yay)
      aur_updates=$(yay -Qua 2>/dev/null | wc -l)
      ;;
    *)
      aur_updates=$("$aur_helper" -Qua 2>/dev/null | wc -l)
      ;;
    esac
  fi

  # Check for Flatpak updates
  local flatpak_updates=0
  if pkg_installed flatpak; then
    flatpak_updates=$(flatpak remote-ls --updates 2>/dev/null | wc -l)
  fi

  # Calculate total updates
  local total_updates=$((official_updates + aur_updates + flatpak_updates))

  # Build tooltip
  local tooltip=""
  if [[ $total_updates -eq 0 ]]; then
    tooltip="System is up to date"
    send_notification normal "$tooltip"
    echo '{"text": "", "tooltip": "System is up to date"}'
  else
    # Build detailed tooltip
    tooltip="Updates available:\\n"
    tooltip+="Official: $official_updates\\n"
    tooltip+="AUR: $aur_updates"
    if pkg_installed flatpak; then
      tooltip+="\\nFlatpak: $flatpak_updates"
    fi

    send_notification normal "$total_updates packages available"
    echo "{\"text\": \"󰅢 $total_updates\", \"tooltip\": \"$tooltip\"}"
  fi

  rm -f "$LOCK_FILE"
}

# Function to perform updates
perform_updates() {
  if [[ -f "$LOCK_FILE" ]]; then
    send_notification critical "Update check in progress. Please wait."
    return 1
  fi

  send_notification normal "Starting system update..."

  # Detect AUR helper for updates
  local aur_helper
  aur_helper=$(detect_aur_helper)

  # Prepare update commands
  local update_cmd=""
  if [[ -n "$aur_helper" ]]; then
    case "$aur_helper" in
    paru)
      update_cmd="paru -Syu"
      ;;
    yay)
      update_cmd="yay -Syu"
      ;;
    *)
      update_cmd="$aur_helper -Syu"
      ;;
    esac
  else
    update_cmd="sudo pacman -Syu"
  fi

  # Add flatpak update if installed
  local flatpak_cmd=""
  if pkg_installed flatpak; then
    flatpak_cmd="flatpak update"
  fi

  # Build complete update command
  local full_cmd="$update_cmd"
  if [[ -n "$flatpak_cmd" ]]; then
    full_cmd="$update_cmd && echo && echo 'Updating Flatpak packages...' && $flatpak_cmd"
  fi

  # Run update in a new terminal window
  $TERMINAL -e bash -c "$full_cmd && echo && echo 'Update completed successfully' || echo 'Update failed'; echo 'Press any key to exit...'; read -n 1"

  # Refresh waybar after update
  pkill -RTMIN+20 waybar 2>/dev/null || true
}

# Main logic
case "$1" in
up)
  perform_updates
  ;;
*)
  check_updates
  ;;
esac
