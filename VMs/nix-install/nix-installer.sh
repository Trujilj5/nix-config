#!/bin/bash

echo "Installing Nix for user: $SUDO_USER"

# Install Nix with flakes enabled
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate

# Switch to real user for home-manager setup
sudo -u "$SUDO_USER" bash << EOF
# Source nix for current session
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Create home-manager flake configuration
mkdir -p /home/$SUDO_USER/.config/home-manager
cat > /home/$SUDO_USER/.config/home-manager/flake.nix << 'FLAKE_EOF'
{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: {
    homeConfigurations."$SUDO_USER" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        {
          home.username = "$SUDO_USER";
          home.homeDirectory = "/home/$SUDO_USER";
          home.stateVersion = "23.11";

          home.packages = with nixpkgs.legacyPackages.x86_64-linux; [
            # Add packages here through https://search.nixos.org/packages?channel=unstable
            # vim
            # neovim
          ];

          programs.zed-editor = {
            enable = true;
          };

          programs.home-manager.enable = true;
        }
      ];
    };
  };
}
FLAKE_EOF

# Install and activate home-manager
cd /home/$SUDO_USER/.config/home-manager
nix run home-manager/master -- switch --flake .#$SUDO_USER
EOF

echo ""
echo "Home Manager installed! Zed editor is now available system-wide."
echo ""
echo "Launch with: zed"
echo ""
echo "To add more packages:"
echo "1. Edit ~/.config/home-manager/flake.nix"
echo "2. Run: home-manager switch --flake ~/.config/home-manager"
echo ""
echo "To uninstall: /nix/nix-installer uninstall"
