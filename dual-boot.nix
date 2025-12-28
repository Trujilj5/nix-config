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
      description = "UUID of the gaming drive's EFI partition";
    };

    menuTitle = lib.mkOption {
      type = lib.types.str;
      default = "Gaming NixOS";
      description = "Title shown in boot menu";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.loader.systemd-boot.extraEntries = {
      "gaming-nixos.conf" = ''
        title ${cfg.menuTitle}
        efi /EFI/systemd/systemd-bootx64.efi
        options root=PARTUUID=${cfg.gamingDriveUUID}
      '';
    };

    # Add efibootmgr for managing boot entries
    environment.systemPackages = [ pkgs.efibootmgr ];
  };
}
