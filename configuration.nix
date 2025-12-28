{ lib, ... }:

{
  # Define your username here (used across system configuration)
  _module.args.systemUser = "john";

  imports = [
    ./desktop.nix
    ./dotfiles
    ./dev.nix
    ./hardware-configuration.nix
    ./stylix.nix
    ./dual-boot.nix
  ];

  # Enable dual-boot for gaming drive (disable if not present)
  system.dualBoot.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;  # Keep last 10 generations

  # Enable dual-boot menu
  boot.loader.timeout = 5;  # Wait 5 seconds at boot menu

  # Plymouth for prettier boot splash (including LUKS password prompt)
  boot.plymouth.enable = true;
  boot.plymouth.theme = lib.mkForce "bgrt";  # Use motherboard boot logo (press Escape to see logs)
  boot.initrd.systemd.enable = true;  # Enable systemd in initrd for graphical LUKS prompt
  boot.kernelParams = [ "splash" "quiet" ];  # Graphical splash (press Escape during boot for text logs)

  networking.networkmanager.enable = true;
  networking.wireless.enable = false;

  # Set timezone
  time.timeZone = "America/Phoenix";

  # Set locale
  i18n.defaultLocale = "en_US.UTF-8";

  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = true;

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";

}
