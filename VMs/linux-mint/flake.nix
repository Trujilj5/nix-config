{
  description = "Linux Mint QEMU VM";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      runVM = pkgs.writeShellScriptBin "run-mint-vm" ''
        if [ ! -f mint.qcow2 ]; then
          echo "Creating VM disk..."
          ${pkgs.qemu}/bin/qemu-img create -f qcow2 mint.qcow2 20G
        fi

        echo "Running Linux Mint VM..."
        ${pkgs.qemu}/bin/qemu-system-x86_64 \
          -enable-kvm -m 4G -smp 2 \
          -drive file=mint.qcow2,format=qcow2 \
          -device virtio-vga-gl \
          -display gtk,gl=on \
          -device intel-hda -device hda-duplex \
          -usb -device usb-tablet
      '';

      installVM = pkgs.writeShellScriptBin "install-mint-vm" ''
        if [ ! -f mint.qcow2 ]; then
          echo "Creating VM disk..."
          ${pkgs.qemu}/bin/qemu-img create -f qcow2 mint.qcow2 20G
        fi

        if [ -z "$1" ]; then
          echo "Usage: nix run .#install -- /path/to/mint.iso"
          exit 1
        fi

        echo "Installing from ISO: $1"
        ${pkgs.qemu}/bin/qemu-system-x86_64 \
          -enable-kvm -m 4G -smp 2 \
          -drive file=mint.qcow2,format=qcow2 \
          -cdrom "$1" -boot d \
          -device virtio-vga-gl \
          -display gtk,gl=on \
          -device intel-hda -device hda-duplex \
          -usb -device usb-tablet
      '';
    in
    {
      packages.${system} = {
        default = runVM;
        install = installVM;
      };

      apps.${system} = {
        default = {
          type = "app";
          program = "${runVM}/bin/run-mint-vm";
        };
        install = {
          type = "app";
          program = "${installVM}/bin/install-mint-vm";
        };
      };
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          qemu
          qemu_kvm
          gtk3
        ];

        shellHook = ''
          echo "Linux Mint VM Environment"
          echo "========================"
          echo ""
          echo "Usage:"
          echo "  nix run                                - Run VM (creates disk if needed)"
          echo "  nix run .#install -- linuxmint-22.2-cinnamon-64bit.iso - Install from ISO"
          echo ""
          echo "Manual commands (if needed):"
          echo "  qemu-img create -f qcow2 mint.qcow2 20G"
          echo "  qemu-system-x86_64 -enable-kvm -m 4G -smp 2 -drive file=mint.qcow2,format=qcow2 -device virtio-vga-gl -display gtk,gl=on"
          echo ""
        '';
      };
    };
}
