{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    portalPackage = null;  # Use portal from system config instead
    extraConfig = builtins.readFile ../config/hypr/hyprland.conf;
  };

  systemd.user.services.hyprland-monitor-autodetect = {
    Unit = {
      Description = "Hyprland monitor autodetection";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellApplication {
        name = "hyprland-monitor-autodetect";
        runtimeInputs = [ pkgs.hyprland pkgs.jq pkgs.coreutils pkgs.gnugrep ];
        text = builtins.readFile ../config/hypr/scripts/autodetect-monitors.sh;
      }}/bin/hyprland-monitor-autodetect";
      RemainAfterExit = false;
    };

    Install = {
      WantedBy = [ "hyprland-session.target" ];
    };
  };

  home.packages = with pkgs; [
    hyprlock
    hypridle
    dunst
    xarchiver
  ];
}
