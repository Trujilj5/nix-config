# dotfiles/home-manager/default.nix - Central import for all Home Manager configurations
{ ... }:

{
  imports = [
    ./zsh.nix
    ./hyprland.nix
    ./waybar.nix
    ./wofi.nix
    ./zed.nix
    ./nvim.nix
    ./ghostty.nix
    ./tmux.nix
    # Add more home-manager dotfile configs here as you create them
    # ./git.nix
    # ./alacritty.nix
    # ./firefox.nix
  ];
}
