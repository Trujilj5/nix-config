#!/bin/bash

# Install Nix with flakes enabled
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate

# Source nix for current session
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Install home-manager (non-flake approach)
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

# Install home-manager
nix-shell '<home-manager>' -A install

# Create home-manager configuration
mkdir -p ~/.config/home-manager
cat > ~/.config/home-manager/home.nix << 'EOF'
{ config, pkgs, ... }:

{
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    zed-editor
  ];

  programs.home-manager.enable = true;
}
EOF

# Apply the configuration
home-manager switch

echo ""
echo "Home Manager installed! Packages are now available system-wide."
echo ""
echo "Zed editor installed! Launch with 'zed' command."
echo ""
echo "To add more packages:"
echo "1. Edit ~/.config/home-manager/home.nix"
echo "2. Add packages to the home.packages list"
echo "3. Run: home-manager switch"
echo ""
echo "To uninstall: /nix/nix-installer uninstall"