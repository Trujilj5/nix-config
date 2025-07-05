# /etc/nixos/desktop.nix
{ config, pkgs, lib, unstablePkgs, ... }:

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

  services.gnome.gnome-keyring.enable = true;
  # services.pam.services.gdm.enableGnomeKeyring = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.printing.enable = true;

  fonts.packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.jetbrains-mono
      jetbrains-mono
      meslo-lgs-nf
    ];

  environment.systemPackages = with pkgs; [
    filezilla
    brave
    firefox
    spotify
    discord
    unstablePkgs.nwg-look
    gvfs
    udisks2
    wireplumber
    pulseaudio
    teams-for-linux
    python3Packages.requests
    wlogout
    networkmanagerapplet
  ];
}
