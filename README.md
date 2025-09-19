# CachyOS Dotfiles

Personal configuration files for CachyOS Linux with Hyprland, featuring a performance-optimized desktop setup.

## What's Included

- **Hyprland**: Wayland compositor with custom keybinds and window rules
- **Waybar**: Status bar with system monitoring and CachyOS theme
- **Fish Shell**: With custom abbreviations and functions
- **Kitty**: Terminal with Catppuccin theme and transparency
- **Rofi**: Application launcher with clipboard management (rofi-wayland)
- **Web2App**: Custom Fish functions to create web apps from any website

## Key Features

- 🚀 **CachyOS Optimized**: Tuned for performance and efficiency
- 🎨 **Catppuccin Theme**: Consistent purple/blue color scheme
- ⚡ **Custom Web Apps**: Turn any website into a desktop app
- 🐟 **Fish Shell Setup**: With starship prompt and useful abbreviations
- 🔧 **Modular Config**: Clean separation using GNU Stow

## Quick Install

1. **Install dependencies**:
```bash
# Run the provided install script (⚠️ Beta - not fully tested)
./scripts/bin/arch_install_script.sh
```

2. **Clone and apply dotfiles**:
```bash
git clone https://github.com/yourusername/cachyos-dotfiles.git ~/dotfiles
cd ~/dotfiles
stow */
```

3. **Set Fish as default shell**:
```bash
chsh -s /usr/bin/fish
```

## Custom Features

### Web2App Functions
Create desktop applications from websites:
```bash
web2app                           # Interactive mode
web2app "YouTube" "https://youtube.com" "icon-url.png"
web2app-list                      # List installed web apps
web2app-remove "AppName"          # Remove web app
```

### Fish Abbreviations
- `gst` → `git status`
- `gco` → `git commit -m`
- `ls` → `eza -lh --icons=auto`
- `n` → `nvim`
- `ff` → `fzf --preview='bat --color=always {}'`

### Key Shortcuts
- `Super + T` - Terminal (Kitty)
- `Super + E` - File manager (Thunar)
- `Super + B` - Browser (Brave)
- `Super + Space` - App launcher (Rofi)
- `Super + Shift + V` - Clipboard history
- `Super + Print` - Screenshot selection
- `Super + Escape` - Powermenu

## Requirements

- CachyOS Linux
- Hyprland compositor
- Fish shell
- GNU Stow for dotfiles management

## Screenshot

<img width="1920" height="1080" alt="screenshot_2025-09-19_09-39-10" src="https://github.com/user-attachments/assets/68c7fdfb-6278-45e7-a02f-eb504ccc8c2a" />
<img width="1920" height="1080" alt="screenshot_2025-09-19_09-42-08" src="https://github.com/user-attachments/assets/25bcf5f6-1e7d-4926-ab95-087a129a847a" />
<img width="1920" height="1080" alt="screenshot_2025-09-19_09-46-12" src="https://github.com/user-attachments/assets/74e3ea72-0056-4410-94ca-2a24fc52c5ce" />
<img width="1920" height="1080" alt="screenshot_2025-09-19_10-01-03" src="https://github.com/user-attachments/assets/dade1f0d-100d-4636-b763-c51daf6af0ba" />
<img width="1920" height="1080" alt="screenshot_2025-09-19_10-01-28" src="https://github.com/user-attachments/assets/759f28ee-e02c-4a4d-b598-807cbe1f450e" />
<img width="1920" height="1080" alt="screenshot_2025-09-19_10-00-44" src="https://github.com/user-attachments/assets/05b1c22d-d1b6-4cda-8be1-984596ba05a2" />


## License

MIT License - see [LICENSE](LICENSE) file.

---

*Optimized for CachyOS performance and daily productivity.*
