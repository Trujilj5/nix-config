{ lib, ... }:

{
  imports = [
    ./desktop.nix
    ./dotfiles
    ./dev.nix
    /etc/nixos/hardware-configuration.nix
    ./stylix.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  networking.wireless.enable = false;

  # Set timezone
  time.timeZone = "America/Phoenix";

  # Set locale
  i18n.defaultLocale = "en_US.UTF-8";

  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";

}
