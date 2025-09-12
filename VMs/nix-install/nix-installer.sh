#!/bin/bash

# Install Nix with flakes enabled
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate

# Source nix for current session
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Create a basic flake for package management
mkdir -p ~/.config/nix-packages
cat > ~/.config/nix-packages/flake.nix << 'EOF'
{
  description = "My packages";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  
  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          # Add your packages here
          git
          vim
          curl
          wget
        ];
      };
    };
}
EOF

echo ""
echo "Nix installed! Add packages to ~/.config/nix-packages/flake.nix"
echo "Then run: cd ~/.config/nix-packages && nix develop"
echo ""
echo "To uninstall: /nix/nix-installer uninstall"

