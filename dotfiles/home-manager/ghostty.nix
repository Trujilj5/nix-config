# dotfiles/home-manager/ghostty.nix - Ghostty terminal configuration
{ pkgs, ... }:

{
  # Install Ghostty terminal
  home.packages = with pkgs; [
    ghostty
  ];

  # Manage Ghostty configuration files
  home.file = {
    # Main configuration file
    ".config/ghostty/config".source = ../config/ghostty/config;
  };
}
