#!/bin/bash
#
# Web2App Install Script
# Minimal script to install only web2app dependencies
# Assumes Fish/Kitty/Hyprland already installed and dotfiles will be copied separately
#

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Install required packages for web2app
install_web2app_packages() {
    print_status "Installing web2app dependencies..."
    
    local packages=(
        "gum"           # For interactive prompts in web2app
        "curl"          # For downloading icons
        "chromium"      # For creating web apps
    )
    
    # Check if yay is available, otherwise use pacman
    if command -v yay &> /dev/null; then
        print_status "Using yay for package installation..."
        yay -S --needed --noconfirm "${packages[@]}"
    else
        print_status "Using pacman for package installation..."
        sudo pacman -S --needed --noconfirm "${packages[@]}"
    fi
    
    print_success "Web2app dependencies installed"
}

# Create necessary directories for web apps
create_web2app_directories() {
    print_status "Creating web2app directories..."
    
    local dirs=(
        "$HOME/.local/share/applications"
        "$HOME/.local/share/applications/icons"
    )
    
    for dir in "${dirs[@]}"; do
        mkdir -p "$dir"
        print_status "Created: $dir"
    done
    
    print_success "Directories created"
}

# Test if everything is working
test_web2app() {
    print_status "Testing web2app dependencies..."
    
    # Test required commands
    local commands=("chromium" "curl" "gum")
    local all_good=true
    
    for cmd in "${commands[@]}"; do
        if command -v "$cmd" &> /dev/null; then
            print_success "$cmd is available"
        else
            print_error "$cmd is not available"
            all_good=false
        fi
    done
    
    # Check directories
    if [ -d "$HOME/.local/share/applications" ]; then
        print_success "Applications directory exists"
    else
        print_error "Applications directory missing"
        all_good=false
    fi
    
    if $all_good; then
        print_success "All web2app dependencies are ready!"
    else
        print_error "Some dependencies are missing"
        return 1
    fi
}

# Main installation process
main() {
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════╗"
    echo "║              Web2App Install Script              ║"
    echo "║                                                  ║"
    echo "║  This script will install:                       ║"
    echo "║  • gum (interactive prompts)                     ║"
    echo "║  • curl (download icons)                         ║"
    echo "║  • chromium (web app browser)                    ║"
    echo "║  • Create necessary directories                  ║"
    echo "╚══════════════════════════════════════════════════╝"
    echo -e "${NC}\n"
    
    read -p "Continue with installation? (Y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        print_status "Installation cancelled"
        exit 0
    fi
    
    print_status "Installing web2app dependencies..."
    
    install_web2app_packages
    create_web2app_directories
    test_web2app
    
    echo -e "\n${GREEN}"
    echo "╔══════════════════════════════════════════════════╗"
    echo "║         🎉 Web2App Dependencies Installed! 🎉   ║"
    echo "╚══════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    print_success "Installation complete!"
    print_status "Next steps:"
    echo -e "  1. Copy your Fish functions from dotfiles to ${YELLOW}~/.config/fish/functions/${NC}"
    echo -e "  2. Restart your terminal or reload Fish config"
    echo -e "  3. Test with: ${YELLOW}web2app${NC}"
    echo -e "\n${BLUE}Ready for web2app! 🚀${NC}\n"
}

# Run main function
main "$@"
