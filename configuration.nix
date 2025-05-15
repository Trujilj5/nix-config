# /etc/nixos/configuration.nix
{ config, pkgs, lib, ... }:

let
  unstablePkgs = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz";
  }) { inherit (pkgs) system; };
in
{
  imports = [
    ./hardware.nix
    ./desktop.nix
    ./zsh.nix
    ./dev.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.11";
}
