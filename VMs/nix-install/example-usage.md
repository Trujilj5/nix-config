# Nix Package Management in Linux Mint VM

After running the installer script, you'll have a basic flake setup for declarative package management.

## Quick Start

1. **Enter the Nix environment:**
   ```bash
   cd ~/.config/nix-packages
   nix develop
   ```

2. **Add more packages:**
   Edit `~/.config/nix-packages/flake.nix` and add packages to the list:
   ```nix
   packages = with pkgs; [
     git
     vim
     curl
     wget
     # Add new packages here:
     firefox
     vscode
     htop
   ];
   ```

3. **Apply changes:**
   ```bash
   nix develop
   ```

## Example Packages

Common packages you might want:
- `firefox` - Web browser
- `vscode` - Code editor  
- `htop` - System monitor
- `nodejs` - Node.js runtime
- `python3` - Python interpreter
- `docker` - Container runtime
- `neofetch` - System info

## Usage Pattern

1. Edit the flake.nix file to add/remove packages
2. Run `nix develop` to enter the environment with those packages
3. All packages are available in that shell session
4. Exit with `exit` or Ctrl+D

This keeps your base Linux Mint system clean while giving you declarative package management through Nix.