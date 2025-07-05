{ config, pkgs, inputs, ... }:

{
  # Configure Hyprland through Home Manager
  wayland.windowManager.hyprland = {
    enable = true;
    # Let Home Manager manage the Hyprland package
    # package = pkgs.hyprland; # Uncomment if you want to override the system package

    # Import your existing configuration
    extraConfig = builtins.readFile ../config/hypr/hyprland.conf;
  };



  # Install Hyprland-related packages
  home.packages = with pkgs; [
    # Core Wayland utilities
    hyprpaper
    hyprlock
    hypridle
    grim
    slurp
    dunst

    # File manager
    xfce.thunar
    xfce.thunar-volman
    
    # Archive support for Thunar
    xarchiver
    
    # Theme packages
    dracula-theme
    dracula-icon-theme
  ];
}
