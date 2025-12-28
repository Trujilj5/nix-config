{ pkgs, unstablePkgs, inputs, systemUser, lib, ... }:

{

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableHardening = false;
  # Fix vboxnet0 boot timeout - don't wait for device at boot
  systemd.services.vboxnet0 = {
    unitConfig.DefaultDependencies = false;
    wantedBy = lib.mkForce [ "multi-user.target" ];
  };
  users.extraGroups.vboxusers.members = [ systemUser ];

  services.tailscale.enable = true;

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      log-driver = "json-file";
      log-opts = {
        max-size = "10m";
        max-file = "3";
      };
    };
  };

  services.k3s = {
    # enable = true;
    enable = false;
    role = "server";
    extraFlags = toString [
      "--disable=traefik"
      "--write-kubeconfig-mode=644"
      "--docker"
      "--flannel-backend=host-gw"  # Use host-gw instead of vxlan (simpler, works better with dynamic IPs)
    ];
  };

  # Ensure k3s waits for network to be fully ready and clean stale state
  systemd.services.k3s = {
    after = [ "network-online.target" "docker.service" ];
    wants = [ "network-online.target" ];
    preStart = ''
      # Clean up stale Docker containers from previous k3s runs
      ${pkgs.docker}/bin/docker rm -f $(${pkgs.docker}/bin/docker ps -aq --filter "label=io.cri-containerd.kind=sandbox") 2>/dev/null || true
    '';
  };

  environment.systemPackages = with pkgs; [
    inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.default
    vim
    wget
    unstablePkgs.opencode
    unstablePkgs.claude-code
    unstablePkgs.freerdp
    unstablePkgs.winboat
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
    openjdk
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


  # Copy k3s kubeconfig to user's home directory
  systemd.services.k3s-copy-config = {
    description = "Copy k3s kubeconfig to user directory";
    after = [ "k3s.service" ];
    wants = [ "k3s.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = false;
      Restart = "on-failure";
      RestartSec = "5s";
    };
    script = ''
      # Wait for k3s to be fully ready and kubeconfig to exist
      timeout=60
      while [ $timeout -gt 0 ] && [ ! -f /etc/rancher/k3s/k3s.yaml ]; do
        sleep 1
        timeout=$((timeout - 1))
      done

      if [ ! -f /etc/rancher/k3s/k3s.yaml ]; then
        echo "Timeout waiting for k3s.yaml"
        exit 1
      fi

      # Wait an additional second to ensure file is fully written
      sleep 1

      mkdir -p /home/${systemUser}/.kube
      cp /etc/rancher/k3s/k3s.yaml /home/${systemUser}/.kube/config
      chown ${systemUser}:users /home/${systemUser}/.kube/config
      chmod 600 /home/${systemUser}/.kube/config
      echo "Successfully copied k3s kubeconfig"
    '';
  };
}
