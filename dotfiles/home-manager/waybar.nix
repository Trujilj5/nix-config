{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    waybar
  ];

  home.file = {
    ".config/waybar/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/dotfiles/config/waybar/config";
    ".config/waybar/style.css".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/dotfiles/config/waybar/style.css";
    ".config/waybar/scripts/control-workspace-notifications.sh".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/dotfiles/config/waybar/scripts/control-workspace-notifications.sh";
    ".config/waybar/scripts/english-date.sh".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/dotfiles/config/waybar/scripts/english-date.sh";
    ".config/waybar/scripts/waybar-startup.sh".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/dotfiles/config/waybar/scripts/waybar-startup.sh";
    ".config/waybar/scripts/weather-phoenix.sh".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/dotfiles/config/waybar/scripts/weather-phoenix.sh";
    ".config/waybar/scripts/weather-us.py".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/dotfiles/config/waybar/scripts/weather-us.py";
    ".config/waybar/scripts/workspace-notifications.py".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/dotfiles/config/waybar/scripts/workspace-notifications.py";
  };
}
