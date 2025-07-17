# /etc/nixos/dev.nix
{ config, pkgs, lib, unstablePkgs, masterPkgs, ... }:

{

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "john" ];

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
    baobab
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
