{ pkgs, unstablePkgs, ... }:

{
  services.xserver.enable = false;
  programs.hyprland = {
    enable = true;
    portalPackage = pkgs.xdg-desktop-portal-wlr;
  };
  programs.xfconf.enable = true;
  programs.thunar.enable = true;

  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  services.gnome.gnome-keyring.enable = true;

  programs.dconf.enable = true;
  services.dbus.enable = true;

  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt";
  };
  
  services.udev.packages = [ pkgs.bazecor ];

  services.udev.extraRules = ''
    # Dygma Defy - USB devices (covers all product IDs: 0010, 0011, 0012, 0013)
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="35ef", MODE="0666", GROUP="users"
    # Dygma Defy - HID raw devices
    KERNEL=="hidraw*", ATTRS{idVendor}=="35ef", MODE="0666", GROUP="users"
  '';
    
  services.gnome.at-spi2-core.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
    config = {
      hyprland = {
        default = ["wlr" "gtk"];
        "org.freedesktop.impl.portal.FileChooser" = "gtk";
        "org.freedesktop.impl.portal.OpenURI" = "gtk";
        "org.freedesktop.impl.portal.ScreenCast" = "wlr";
        "org.freedesktop.impl.portal.Screenshot" = "wlr";
      };
    };
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

  environment.systemPackages = with pkgs; [
    filezilla
    (writeShellScriptBin "brave" ''
      exec ${brave}/bin/brave --force-device-scale-factor=1.0 --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer --ozone-platform=wayland "$@"
    '')
    firefox
    spotify
    (writeShellScriptBin "discord" ''
      export GDK_SCALE=0.5
      export GDK_DPI_SCALE=0.5
      exec ${discord}/bin/discord --force-device-scale-factor=1.0 --high-dpi-support=1 --force-device-scale-factor=1.0 "$@"
    '')
    unstablePkgs.nwg-look
    blueman
    wireplumber
    pulseaudio
    (pkgs.makeDesktopItem {
      name = "bazecor";
      desktopName = "Bazecor";
      exec = "${bazecor}/bin/bazecor --force-device-scale-factor=2 --enable-features=UseOzonePlatform --ozone-platform=wayland";
      icon = "bazecor";
      comment = "Graphical configurator for Dygma products";
      categories = [ "Utility" ];
    })
    btop
    python3Packages.requests
    wlogout
    networkmanagerapplet
    (writeShellScriptBin "signal-desktop" ''
      exec ${signal-desktop-bin}/bin/signal-desktop --force-device-scale-factor=0.25 --enable-features=UseOzonePlatform --ozone-platform=wayland "$@"
    '')
    (writeShellScriptBin "zed-project-picker" ''
      #!/usr/bin/env bash

      # Simple Yazi launcher for project selection
      # Yazi handles opening projects in workspace 2 directly

      # Default starting directory (you can customize this)
      START_DIR="''${1:-$HOME}"

      # Launch Yazi
      ${yazi}/bin/yazi "$START_DIR"
    '')

    gsettings-desktop-schemas
    glib
    glib-networking
    xlsx2csv
    teams-for-linux
  ];


}
