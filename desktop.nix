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
    
    # Theme packages
    catppuccin-gtk
    papirus-icon-theme
    catppuccin-cursors
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    qt6ct
    adwaita-qt
    adwaita-qt6
  ];

  # System-wide DPI and scaling configuration
  environment.sessionVariables = {
    # Fix DPI scaling system-wide
    GDK_SCALE = "1";
    GDK_DPI_SCALE = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "0";
    QT_SCALE_FACTOR = "1";
    QT_FONT_DPI = "96";
    XCURSOR_SIZE = "24";
  };
}
