{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ../config/hypr/hyprland.conf;
  };

  home.packages = with pkgs; [
    hyprlock
    hypridle
    dunst
    xarchiver
  ];
}
