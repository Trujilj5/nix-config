# /etc/nixos/dev.nix
{ config, pkgs, ... }:

let
  unstablePkgs = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz";
  }) { inherit (pkgs) system; };
in
{
  virtualisation.docker.enable = true;

  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = "--disable=traefik";
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    neovim
    git
    lazygit
    bluetui
    unstablePkgs.zed-editor-fhs
    cmake
    meson
    cpio
    kubectl
    k3s
    openssh
    unstablePkgs.bun
    patchelf
    glib
    glibc
    python3
    openjdk23
    docker
    lens
    unstablePkgs.nodejs
    busybox
    dolt
    vscodium-fhs
    maven
    tmux
    unstablePkgs.argocd
    unstablePkgs.kubernetes-helm
  ];

  systemd.user.services.podman-api = {
    description = "Podman API Service for kubectl";
    after = [ "network.target" "podman.socket" ];
    wants = [ "network.target" "podman.socket" ];
    wantedBy = [ "multi-user.target" "default.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.podman}/bin/podman system service --listen-address 0.0.0.0:8081 -t 0";
      Restart = "always";
      Type = "simple";
    };
  };
}
