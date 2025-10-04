{ pkgs, unstablePkgs, ... }:

{
  # Gaming-specific configuration
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # Enable 32-bit support for gaming
  hardware.graphics.enable32Bit = true;

  # Enable GameMode for better gaming performance
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    # Essential tools for config editing
    vim
    neovim
    unstablePkgs.claude-code
    git
    wget
    openssh

    # Gaming - Steam
    steam
    steam-run

    # Gaming - Battle.net/WoW via Lutris
    lutris

    # Wine dependencies for Battle.net
    (wineWowPackages.full.override {
      wineRelease = "staging";
      mingwSupport = true;
    })
    winetricks

    # Additional dependencies for Battle.net/WoW
    dxvk
    vkd3d
    mangohud
    gamemode

    # Utilities
    zoxide
    fzf
  ];

  # Environment variables for gaming
  environment.sessionVariables = {
    # Enable Vulkan for better performance
    ENABLE_VKBASALT = "1";
  };
}
