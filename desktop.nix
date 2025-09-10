{ pkgs, unstablePkgs, ... }:

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

  programs.dconf.enable = true;
  services.dbus.enable = true;

  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt";
  };

  services.gnome.at-spi2-core.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
    config = {
      common = {
        default = "gtk";
        "org.freedesktop.impl.portal.FileChooser" = "gtk";
        "org.freedesktop.impl.portal.OpenURI" = "gtk";
      };
      hyprland = {
        default = ["hyprland" "gtk"];
        "org.freedesktop.impl.portal.FileChooser" = "gtk";
        "org.freedesktop.impl.portal.OpenURI" = "gtk";
        "org.freedesktop.impl.portal.ScreenCast" = "hyprland";
        "org.freedesktop.impl.portal.Screenshot" = "hyprland";
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
      exec ${brave}/bin/brave --force-device-scale-factor=1.0 --enable-features=UseOzonePlatform --ozone-platform=wayland "$@"
    '')
    firefox
    spotify
    (writeShellScriptBin "discord" ''
      export GDK_SCALE=0.5
      export GDK_DPI_SCALE=0.5
      exec ${discord}/bin/discord --force-device-scale-factor=1.0 --high-dpi-support=1 --force-device-scale-factor=1.0 "$@"
    '')
    unstablePkgs.nwg-look

    wireplumber
    pulseaudio
    btop
    python3Packages.requests
    wlogout
    networkmanagerapplet
    (writeShellScriptBin "signal-desktop" ''
      exec ${signal-desktop-bin}/bin/signal-desktop --force-device-scale-factor=0.25 --enable-features=UseOzonePlatform --ozone-platform=wayland "$@"
    '')
    (writeShellScriptBin "zed-project-picker" ''
      #!/usr/bin/env bash

      # Zed Project Picker using Yazi
      # This script opens Yazi file manager to select a project directory,
      # then opens that directory in Zed Editor and closes the terminal.

      set -e

      # Default starting directory (you can customize this)
      START_DIR="''${1:-$HOME}"

      # Temporary file to store the selected directory
      TEMP_FILE=$(mktemp)

      # Function to cleanup temp file on exit
      cleanup() {
          rm -f "$TEMP_FILE"
      }
      trap cleanup EXIT

      # Launch Yazi and capture the selected directory
      ${yazi}/bin/yazi "$START_DIR" --cwd-file="$TEMP_FILE"

      # Check if a directory was selected
      if [[ -f "$TEMP_FILE" ]]; then
          SELECTED_DIR=$(cat "$TEMP_FILE")

          # Only proceed if a directory was actually selected (different from start)
          if [[ -n "$SELECTED_DIR" && -d "$SELECTED_DIR" ]]; then
              echo "Opening $SELECTED_DIR in Zed..."
              # Switch to workspace 2 and open Zed there
              hyprctl dispatch workspace 2
              sleep 0.1
              hyprctl dispatch exec "zed-fhs \"$SELECTED_DIR\""
          else
              echo "No directory selected or invalid directory."
              exit 1
          fi
      else
          echo "No directory selected."
          exit 1
      fi
    '')

    gsettings-desktop-schemas
    glib
    glib-networking
  ];


}
