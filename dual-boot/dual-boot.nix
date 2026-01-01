{ config, lib, pkgs, ... }:

let
  cfg = config.system.dualBoot;
in
{
  options.system.dualBoot = {
    enable = lib.mkEnableOption "dual-boot configuration for gaming NixOS";

    gamingDriveUUID = lib.mkOption {
      type = lib.types.str;
      default = "dde141ee-6c2a-4325-89cf-cfb139e84d12";
      description = "UUID of the gaming drive's EFI partition (PARTUUID)";
    };

    maxGenerations = lib.mkOption {
      type = lib.types.int;
      default = 3;
      description = "Maximum number of NixOS generations to show in boot menu";
    };
  };

  config = lib.mkMerge [
    # When dual-boot is enabled, use rEFInd for graphical boot menu
    (lib.mkIf cfg.enable {
      boot.loader.systemd-boot.enable = false;
      boot.loader.grub.enable = false;
      boot.loader.refind = {
        enable = true;
        maxGenerations = cfg.maxGenerations;
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

          # Hide the auto-scanned gaming drive entries (use default Linux icon)
          # dont_scan_volumes ${cfg.gamingDriveUUID}
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
            "EFI/refind/icons/os_nixos.png" = ./icons/nixos.png;
          };
      };
    })

    # When dual-boot is disabled, use systemd-boot
    (lib.mkIf (!cfg.enable) {
      boot.loader.systemd-boot.enable = lib.mkDefault true;
      boot.loader.systemd-boot.configurationLimit = lib.mkDefault 10;
    })
  ];
}
