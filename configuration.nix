{ lib, pkgs, ... }:

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

  # Disable dual-boot module (rEFInd auto-detects both OSes)
  system.dualBoot.enable = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use rEFInd instead of systemd-boot for prettier dual-boot menu
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = false;  # Explicitly disable GRUB
  boot.loader.refind = {
    enable = true;
    maxGenerations = 2;
    extraConfig = ''
      # Scan all drives for bootable OSes
      scanfor manual,external,optical,internal

      # Timeout before auto-booting default entry
      timeout 5

      # Use firmware default graphics mode (mode 0)
      resolution 0

      # Show graphics for boot entries
      use_graphics_for osx,linux,elilo,grub,windows

      # Tell rEFInd where to find icons
      icons_dir EFI/refind/icons

      # Hide boot entries for rescue/fallback kernels
      dont_scan_files shim.efi,shim-fedora.efi,shimx64.efi,PreLoader.efi,TextMode.efi,ebounce.efi,GraphicsConsole.efi,MokManager.efi,HashTool.efi,HashTool-signed.efi,bootmgfw.efi

      # Don't auto-scan gaming drive (we use manual entry below)
      dont_scan_volumes dde141ee-6c2a-4325-89cf-cfb139e84d12

      # Manual entry for Gaming OS with Steam icon
      menuentry "Gaming NixOS" {
        icon EFI/refind/icons/os_steam.png
        volume dde141ee-6c2a-4325-89cf-cfb139e84d12
        loader \EFI\systemd\systemd-bootx64.efi
      }
    '';
    # Copy all icon files to EFI partition
    additionalFiles = let
      refindPath = "${pkgs.refind}/share/refind";
      copyIconsFrom = dir: builtins.listToAttrs (
        map (name: {
          name = "EFI/refind/${dir}/${name}";
          value = "${refindPath}/${dir}/${name}";
        }) (builtins.attrNames (builtins.readDir "${refindPath}/${dir}"))
      );
    in
      (copyIconsFrom "icons") // {
        # Custom NixOS icon for work OS
        "EFI/refind/icons/os_nixos.png" = ./refind-icons/nixos.png;
        # Custom Steam icon for gaming OS
        "EFI/refind/icons/os_steam.png" = ./refind-icons/steam.png;
      };
  };
  boot.loader.efi.canTouchEfiVariables = true;

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
