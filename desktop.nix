# /etc/nixos/desktop.nix
{ config, pkgs, lib, ... }:

let
  unstablePkgs = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz";
  }) { inherit (pkgs) system; };
in

{
  services.xserver.enable = false;
  programs.hyprland.enable = true;
  programs.xfconf.enable = true;
  programs.thunar.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "john";
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.printing.enable = true;

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono" ]; })
    jetbrains-mono
    meslo-lgs-nf
  ];

  environment.systemPackages = with pkgs; [
    brave
    wofi
    waybar
    font-awesome
    hyprshot
    swaynotificationcenter
    ghostty
    wl-clipboard
    networkmanagerapplet
    firefox
    spotify
    discord
    unstablePkgs.nwg-look
    gvfs
    udisks2
    xfce.thunar
    xfce.thunar-volman
    xarchiver
    dracula-theme
    dracula-icon-theme
    wireplumber
    rofi-wayland
    libnotify
    playerctl
    brightnessctl
    pulseaudio
    teams-for-linux
  ];
}
