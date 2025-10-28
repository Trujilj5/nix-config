{ pkgs, unstablePkgs, ... }:

{

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "john" ];

  virtualisation.docker.enable = true;

  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      "--disable=traefik"
      "--node-ip=192.168.1.115"
      "--flannel-iface=wlp4s0"
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    unstablePkgs.opencode
    unstablePkgs.claude-code
    unstablePkgs.freerdp
    neovim
    git
    lazygit
    lazysql
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
    unstablePkgs.docker-compose
    lens
    unstablePkgs.nodejs_24
    busybox
    dolt
    vscodium-fhs
    maven
    unstablePkgs.argocd
    unstablePkgs.kubernetes-helm
    baobab
    nixd
    nil
    unstablePkgs.ngrok
    zoxide
    fzf
    package-version-server
    filezilla
    yarn
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
