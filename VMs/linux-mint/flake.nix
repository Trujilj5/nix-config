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

        if [ "$1" = "--install" ] && [ -n "$2" ]; then
          echo "Installing from ISO: $2"
          ${pkgs.qemu}/bin/qemu-system-x86_64 \
            -enable-kvm -m 4G -smp 2 \
            -drive file=mint.qcow2,format=qcow2 \
            -cdrom "$2" -boot d -display gtk
        else
          echo "Running Linux Mint VM..."
          ${pkgs.qemu}/bin/qemu-system-x86_64 \
            -enable-kvm -m 4G -smp 2 \
            -drive file=mint.qcow2,format=qcow2 \
            -display gtk
        fi
      '';
    in
    {
      packages.${system}.default = runVM;

      apps.${system}.default = {
        type = "app";
        program = "${runVM}/bin/run-mint-vm";
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
          echo "  nix run                    - Run VM (creates disk if needed)"
          echo "  nix run -- --install <iso> - Install from ISO"
          echo ""
          echo "Manual commands (if needed):"
          echo "  qemu-img create -f qcow2 mint.qcow2 20G"
          echo "  qemu-system-x86_64 -enable-kvm -m 4G -smp 2 -drive file=mint.qcow2,format=qcow2 -display gtk"
          echo ""
        '';
      };
    };
}
