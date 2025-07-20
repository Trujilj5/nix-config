# /etc/nixos/desktop.nix
{  pkgs, unstablePkgs, ... }:

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

  # Enable dconf and GTK schemas for proper theme support in Hyprland
  programs.dconf.enable = true;
  services.dbus.enable = true;

  # System-wide environment variables for GTK theming (for Wofi compatibility)
  environment.sessionVariables = {
    GTK_THEME = "Orchis-Dark";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
  };

  # Minimal GSettings setup
  services.gnome.at-spi2-core.enable = true;

  # Desktop portal configuration for proper theming
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "gtk";
  };

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
    (writeShellScriptBin "brave" ''
      exec ${brave}/bin/brave --force-device-scale-factor=0.25 --enable-features=UseOzonePlatform --ozone-platform=wayland "$@"
    '')
    firefox
    spotify
    (writeShellScriptBin "discord" ''
      export GDK_SCALE=0.5
      export GDK_DPI_SCALE=0.5
      exec ${discord}/bin/discord --force-device-scale-factor=1.0 --high-dpi-support=1 --force-device-scale-factor=1.0 "$@"
    '')
    unstablePkgs.nwg-look
    gvfs
    udisks2
    wireplumber
    pulseaudio
    teams-for-linux
    python3Packages.requests
    wlogout
    networkmanagerapplet
    (writeShellScriptBin "signal-desktop" ''
      exec ${signal-desktop}/bin/signal-desktop --force-device-scale-factor=0.25 --enable-features=UseOzonePlatform --ozone-platform=wayland "$@"
    '')

    # Essential GSettings packages
    gsettings-desktop-schemas
    glib
    glib-networking
  ];


}
