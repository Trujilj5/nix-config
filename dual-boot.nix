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
  };

  config = lib.mkIf cfg.enable {
    # Add efibootmgr for managing boot entries
    environment.systemPackages = [ pkgs.efibootmgr ];

    # Create systemd service to ensure gaming OS boot entry exists
    systemd.services.setup-gaming-boot-entry = {
      description = "Setup UEFI boot entry for gaming OS";
      after = [ "local-fs.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        # Set UEFI firmware boot menu timeout to 5 seconds
        ${pkgs.efibootmgr}/bin/efibootmgr --timeout 5

        # Remove duplicate "Gaming NixOS" entry if it exists (Boot0006)
        GAMING_BOOT=$(${pkgs.efibootmgr}/bin/efibootmgr | grep "Boot0006.*Gaming NixOS" | cut -c5-8)
        if [ -n "$GAMING_BOOT" ]; then
          ${pkgs.efibootmgr}/bin/efibootmgr -b "$GAMING_BOOT" -B
        fi

        # Check if any boot entry for gaming drive UUID already exists
        if ! ${pkgs.efibootmgr}/bin/efibootmgr -v | grep -q "${cfg.gamingDriveUUID}"; then
          ${pkgs.efibootmgr}/bin/efibootmgr --create \
            --disk /dev/disk/by-partuuid/${cfg.gamingDriveUUID} \
            --part 1 \
            --label "Gaming NixOS" \
            --loader '\EFI\systemd\systemd-bootx64.efi'
        fi
      '';
    };
  };
}
