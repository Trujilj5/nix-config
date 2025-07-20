{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ../config/hypr/hyprland.conf;
  };

  home.packages = with pkgs; [
    hyprpaper
    hyprlock
    hypridle
    grim
    slurp
    dunst
    xfce.thunar
    xfce.thunar-volman
    xarchiver
  ];
}
