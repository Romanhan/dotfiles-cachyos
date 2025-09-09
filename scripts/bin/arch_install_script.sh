#!/usr/bin/env bash
# ---------------------------------------------
# Script to install yay and selected packages
# Author: [Romanhan]
# Date: September 9, 2025
# ---------------------------------------------

# Exit on any error, treat unset variables as errors, and fail on pipe errors
set -euo pipefail

# Colors for better output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# ---------------------------------------------
# Check and Install yay (AUR Helper)
# ---------------------------------------------
check_and_install_yay() {
    log_info "Checking for yay AUR helper..."
    
    if command -v yay &>/dev/null; then
        log_success "yay is already installed"
        return 0
    fi
    
    log_warning "yay not found"
    read -n1 -rp "Do you want to install yay? (y/n) " INSTYAY
    echo
    
    if [[ ! "$INSTYAY" =~ ^[Yy]$ ]]; then
        log_error "yay is required for this script. Exiting."
        exit 1
    fi
    
    log_info "Installing dependencies for yay..."
    sudo pacman -S --needed --noconfirm git base-devel || {
        log_error "Failed to install yay dependencies"
        exit 1
    }
    
    log_info "Cloning yay repository..."
    local yay_dir="$HOME/.cache/yay"
    rm -rf "$yay_dir" # Remove if exists
    git clone https://aur.archlinux.org/yay.git "$yay_dir" || {
        log_error "Failed to clone yay repository"
        exit 1
    }
    
    log_info "Building and installing yay..."
    cd "$yay_dir" || {
        log_error "Failed to access yay directory"
        exit 1
    }
    
    makepkg -si --noconfirm || {
        log_error "Failed to build yay"
        exit 1
    }
    
    cd - > /dev/null || {
        log_error "Failed to return to previous directory"
        exit 1
    }
    
    log_success "yay installed successfully"
}

# ---------------------------------------------
# Install Packages with yay
# ---------------------------------------------
install_packages() {
    log_info "Installing selected packages with yay..."
    
    # Define package groups for clarity
    local -a desktop_packages=(
        kitty
        zen-browser-bin
        brave-bin
        bibata-cursor-theme
        gnome-calculator
        pavucontrol
        network-manager-applet
        blueman
        brightnessctl
        less
        man
        tree
        eza
        fzf
        zoxide
        bat
        swayimg
        thunar
        thunar-volman
        udisks2
        dunst
        stow
        visual-studio-code-bin
        libreoffice-fresh
        java21-openjfx-bin
    )
    
    local -a wayland_packages=(
        wl-clipboard
        hyprlock
        hypridle
        waybar
        rofi-wayland
        rofimoji
    )
    
    local -a fonts=(
        ttf-cascadia-code-nerd
        ttf-nerd-fonts-symbols-common
        ttf-font-awesome
    )
    
    local -a shell_utils=(
        fish
        starship
        fastfetch
        nvim
        gvim
    )
    
    local -a file_sharing=(
        gvfs
        gvfs-smb
        samba
        smbclient
    )
    
    local -a theming=(
        nwg-look
        kvantum
    )
    
    # Combine all packages
    local -a all_packages=(
        "${desktop_packages[@]}"
        "${wayland_packages[@]}"
        "${fonts[@]}"
        "${shell_utils[@]}"
        "${file_sharing[@]}"
        "${theming[@]}"
    )
    
    log_info "Installing ${#all_packages[@]} packages..."
    
    # Show packages to be installed
    printf '%s\n' "${all_packages[@]}" | column -c 80
    echo
    
    read -n1 -rp "Proceed with installation? (y/n) " PROCEED
    echo
    
    if [[ ! "$PROCEED" =~ ^[Yy]$ ]]; then
        log_warning "Installation cancelled by user"
        exit 0
    fi
    
    # Install all packages with progress indication
    if yay -S --noconfirm --needed "${all_packages[@]}"; then
        log_success "All packages installed successfully"
    else
        log_error "Some packages failed to install. Check the output above."
        return 1
    fi
}

# ---------------------------------------------
# Configure System Services
# ---------------------------------------------
configure_services() {
    log_info "Configuring system services..."
    
    # Enable and start Bluetooth service
    log_info "Enabling Bluetooth service..."
    if sudo systemctl enable --now bluetooth.service; then
        log_success "Bluetooth service enabled and started"
    else
        log_warning "Failed to enable Bluetooth service"
    fi
    
    # Enable Docker service if installed
    if command -v docker &>/dev/null; then
        log_info "Enabling Docker service..."
        sudo systemctl enable --now docker.service
        sudo usermod -aG docker "$USER"
        log_success "Docker service enabled (reboot required for group changes)"
    fi
    
    # Optional: Enable other useful services
    log_info "Would you like to enable additional services?"
    
    # Network Manager (usually already enabled)
    if systemctl is-enabled NetworkManager.service &>/dev/null; then
        log_success "NetworkManager is already enabled"
    else
        read -n1 -rp "Enable NetworkManager? (y/n) " ENABLE_NM
        echo
        if [[ "$ENABLE_NM" =~ ^[Yy]$ ]]; then
            sudo systemctl enable --now NetworkManager.service
            log_success "NetworkManager enabled"
        fi
    fi
}

# ---------------------------------------------
# Post-installation recommendations
# ---------------------------------------------
show_recommendations() {
    log_info "Post-installation recommendations:"
    echo
    echo "1. Configure your shell (Fish is installed):"
    echo "   chsh -s /usr/bin/fish"
    echo
    echo "2. Set up dotfiles with stow (if you have them):"
    echo "   cd ~/dotfiles && stow ."
    echo
    echo "3. Configure Hyprland, Waybar, and other Wayland tools"
    echo
    echo "4. Install additional fonts or themes as needed"
    echo
    echo "5. Configure VS Code extensions and settings"
    echo
}

# ---------------------------------------------
# Cleanup function
# ---------------------------------------------
cleanup() {
    log_info "Cleaning up package cache..."
    yay -Sc --noconfirm || log_warning "Failed to clean package cache"
}

# ---------------------------------------------
# Main Execution
# ---------------------------------------------
main() {
    log_info "Starting Arch Linux package installation script..."
    log_info "This script will install yay and a curated set of packages"
    echo
    
    # Ensure we're on Arch Linux
    if [[ ! -f /etc/arch-release ]]; then
        log_error "This script is designed for Arch Linux only"
        exit 1
    fi
    
    # Update system first
    log_info "Updating system packages..."
    sudo pacman -Syu --noconfirm || {
        log_error "Failed to update system"
        exit 1
    }
    
    # Run main functions
    check_and_install_yay
    install_packages
    configure_services
    cleanup
    
    log_success "✅ Installation complete!"
    show_recommendations
}

# Trap to handle script interruption
trap 'log_error "Script interrupted"; exit 1' INT TERM

# Run the script only if executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi