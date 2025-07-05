# /etc/nixos/configuration.nix
{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./desktop.nix
    ./dotfiles
    ./dev.nix
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  networking.wireless.enable = false;

  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";

  # System-wide DPI and scaling configuration
  services.xserver.dpi = 96;
  environment.variables = {
    GDK_SCALE = "1";
    GDK_DPI_SCALE = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "0";
    QT_SCALE_FACTOR = "1";
    QT_FONT_DPI = "96";
    XCURSOR_SIZE = "24";
  };
}
