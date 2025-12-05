{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    portalPackage = null;  # Use portal from system config instead
    extraConfig = builtins.readFile ../config/hypr/hyprland.conf;
  };

  home.packages = with pkgs; [
    hyprlock
    hypridle
    dunst
    xarchiver
  ];
}
