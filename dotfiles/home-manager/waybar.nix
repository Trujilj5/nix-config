{ pkgs, ... }:

{
  home.packages = with pkgs; [
    waybar
  ];

  home.file = {
    ".config/waybar/config".source = ../config/waybar/config;
    ".config/waybar/style.css".source = ../config/waybar/style.css;
    ".config/waybar/scripts/control-workspace-notifications.sh" = {
      source = ../config/waybar/scripts/control-workspace-notifications.sh;
      executable = true;
    };
    ".config/waybar/scripts/english-date.sh" = {
      source = ../config/waybar/scripts/english-date.sh;
      executable = true;
    };
    ".config/waybar/scripts/waybar-startup.sh" = {
      source = ../config/waybar/scripts/waybar-startup.sh;
      executable = true;
    };
    ".config/waybar/scripts/weather-phoenix.sh" = {
      source = ../config/waybar/scripts/weather-phoenix.sh;
      executable = true;
    };
    ".config/waybar/scripts/weather-us.py" = {
      source = ../config/waybar/scripts/weather-us.py;
      executable = true;
    };
    ".config/waybar/scripts/workspace-notifications.py" = {
      source = ../config/waybar/scripts/workspace-notifications.py;
      executable = true;
    };
  };
}
