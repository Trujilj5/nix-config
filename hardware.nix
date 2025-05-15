# /etc/nixos/hardware.nix
{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_12;  # Override latest from hardware-config
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    lm_sensors
    wdisplays
  ];

  time.timeZone = "America/Phoenix";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
}
