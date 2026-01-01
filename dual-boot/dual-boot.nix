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

          # === rEFInd-minimal Theme ===
          # Hide UI elements for cleaner look (keep labels to show OS names)
          hideui singleuser,hints,arrows,badges

          # Use theme icons directory
          icons_dir themes/rEFInd-minimal/icons

          # Theme background (fills screen)
          banner themes/rEFInd-minimal/background.png
          banner_scale fillscreen

          # Selection highlight images
          selection_big   themes/rEFInd-minimal/selection_big.png
          selection_small themes/rEFInd-minimal/selection_small.png

          # Show shutdown and firmware (BIOS/UEFI) tools
          showtools shutdown,firmware

          # Hide boot entries for rescue/fallback kernels
          dont_scan_files shim.efi,shim-fedora.efi,shimx64.efi,PreLoader.efi,TextMode.efi,ebounce.efi,GraphicsConsole.efi,MokManager.efi,HashTool.efi,HashTool-signed.efi,bootmgfw.efi
        '';
        # Copy theme files to EFI partition
        additionalFiles = let
          themePath = ./themes/rEFInd-minimal;
          refindPath = "${pkgs.refind}/share/refind";
          # Copy all theme icons
          copyThemeIcons = builtins.listToAttrs (
            map (name: {
              name = "themes/rEFInd-minimal/icons/${name}";
              value = "${themePath}/icons/${name}";
            }) (builtins.attrNames (builtins.readDir "${themePath}/icons"))
          );
        in
          copyThemeIcons // {
            # Theme background and selection images
            "themes/rEFInd-minimal/background.png" = "${themePath}/background.png";
            "themes/rEFInd-minimal/selection_big.png" = "${themePath}/selection_big.png";
            "themes/rEFInd-minimal/selection_small.png" = "${themePath}/selection_small.png";
            # Add missing firmware icon from default rEFInd icons
            "themes/rEFInd-minimal/icons/func_firmware.png" = "${refindPath}/icons/func_firmware.png";
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
