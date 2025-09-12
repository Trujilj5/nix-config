#!/bin/bash

# Install Nix with flakes enabled
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
# Uninstall:
# /nix/nix-installer uninstall

# Source nix for current session
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Create home-manager configuration
mkdir -p ~/.config/home-manager
cat > ~/.config/home-manager/flake.nix << 'EOF'
{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      username = builtins.getEnv "USER";
    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          {
            home = {
              username = username;
              homeDirectory = "/home/${username}";
              stateVersion = "23.11";
              packages = with pkgs; [
                zed-editor
              ];
            };
            programs.home-manager.enable = true;
          }
        ];
      };
    };
}
EOF

# Install home-manager
cd ~/.config/home-manager
nix run home-manager/master -- init --switch

echo ""
echo "Home Manager installed! Packages are now available system-wide."
echo ""
echo "To add packages:"
echo "1. Edit ~/.config/home-manager/flake.nix"
echo "2. Run: home-manager switch"
echo ""
echo "To uninstall: /nix/nix-installer uninstall"
