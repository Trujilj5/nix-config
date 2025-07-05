#!/usr/bin/env bash

# Catppuccin Macchiato Theme Setup Script for NixOS + Hyprland
# This script helps you apply the Catppuccin Macchiato theme to your system

set -e

echo "🎨 Catppuccin Macchiato Theme Setup for NixOS + Hyprland"
echo "=========================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_step() {
    echo -e "${BLUE}📋 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if running on NixOS
if [ ! -f /etc/NIXOS ]; then
    print_error "This script is designed for NixOS systems only!"
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "flake.nix" ]; then
    print_error "Please run this script from your NixOS configuration directory!"
    exit 1
fi

print_step "Step 1: Rebuilding NixOS configuration with Catppuccin theme"
echo "This will apply the theme configuration to your system..."

# Rebuild the system
if sudo nixos-rebuild switch --flake . --verbose; then
    print_success "NixOS system rebuilt successfully!"
else
    print_error "Failed to rebuild NixOS system. Please check for errors above."
    exit 1
fi

print_step "Step 2: Rebuilding Home Manager configuration"
echo "This will apply the theme to your user environment..."

# Rebuild Home Manager
if home-manager switch --flake . --verbose; then
    print_success "Home Manager rebuilt successfully!"
else
    print_error "Failed to rebuild Home Manager. Please check for errors above."
    exit 1
fi

print_step "Step 3: Setting up additional theme configurations"

# Create gtk-3.0 and gtk-4.0 directories
mkdir -p "$HOME/.config/gtk-3.0"
mkdir -p "$HOME/.config/gtk-4.0"

# Create a simple gtk-3.0 settings.ini
cat > "$HOME/.config/gtk-3.0/settings.ini" << EOF
[Settings]
gtk-theme-name=Catppuccin-Macchiato-Standard-Blue-Dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=JetBrains Mono 11
gtk-cursor-theme-name=Catppuccin-Macchiato-Blue-Cursors
gtk-cursor-theme-size=24
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull
gtk-xft-rgba=rgb
gtk-application-prefer-dark-theme=1
EOF

# Create a simple gtk-4.0 settings.ini
cat > "$HOME/.config/gtk-4.0/settings.ini" << EOF
[Settings]
gtk-theme-name=Catppuccin-Macchiato-Standard-Blue-Dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=JetBrains Mono 11
gtk-cursor-theme-name=Catppuccin-Macchiato-Blue-Cursors
gtk-cursor-theme-size=24
gtk-application-prefer-dark-theme=1
EOF

print_success "Created GTK configuration files"

print_step "Step 4: Restarting Hyprland services"
echo "Restarting Hyprland services to apply theme changes..."

# Kill and restart hyprpaper
pkill hyprpaper 2>/dev/null || true
hyprpaper &

# Kill and restart waybar
pkill waybar 2>/dev/null || true
waybar &

print_success "Hyprland services restarted"

print_step "Step 5: Final steps and recommendations"

echo ""
echo "🎉 Catppuccin Macchiato theme setup complete!"
echo ""
echo "📋 What was applied:"
echo "   • GTK theme: Catppuccin-Macchiato-Standard-Blue-Dark"
echo "   • Icon theme: Papirus-Dark with Catppuccin folders"
echo "   • Cursor theme: Catppuccin-Macchiato-Blue-Cursors"
echo "   • Hyprland colors: Catppuccin Macchiato palette"
echo "   • Waybar colors: Catppuccin Macchiato palette"
echo "   • Font: JetBrains Mono"
echo ""
echo "🔧 Additional configuration tools:"
echo "   • Run 'nwg-look' to fine-tune GTK theme settings"
echo "   • Run 'qt5ct' to configure Qt5 applications"
echo "   • Run 'qt6ct' to configure Qt6 applications"
echo ""
echo "🚀 Next steps:"
echo "   • Log out and log back in for all changes to take effect"
echo "   • Or restart your Hyprland session: hyprctl dispatch exit"
echo "   • Configure individual applications that don't follow system theme"
echo ""
echo "🐛 Troubleshooting:"
echo "   • If some applications don't follow the theme, try:"
echo "     - Restart the application"
echo "     - Check if the application has its own theme settings"
echo "     - Some applications may need manual configuration"
echo ""
echo "📚 Resources:"
echo "   • Catppuccin: https://github.com/catppuccin/catppuccin"
echo "   • Hyprland theming: https://wiki.hyprland.org/Configuring/Variables/"
echo "   • GTK theming: https://wiki.archlinux.org/title/GTK"
echo ""

# Ask if user wants to restart Hyprland
echo -e "${YELLOW}Would you like to restart Hyprland now to apply all changes? (y/N)${NC}"
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
    print_step "Restarting Hyprland..."
    hyprctl dispatch exit
else
    print_warning "Remember to restart Hyprland when convenient to apply all changes!"
fi

print_success "Theme setup completed successfully! 🎨"