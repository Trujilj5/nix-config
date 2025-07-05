# dotfiles/home-manager/tmux.nix - Tmux terminal multiplexer configuration
{ config, pkgs, ... }:

{
  # Useful Tmux-related packages
  home.packages = with pkgs; [
    tmux-sessionizer
  ];

  # Enable and configure Tmux
  programs.tmux = {
    enable = true;
    clock24 = true;
    
    # Custom configuration from file
    extraConfig = builtins.readFile ../config/tmux/tmux.conf;
  };
}