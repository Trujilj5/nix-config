{ config, pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Ensure direnv config directory exists and add any custom configuration
  home.file.".config/direnv/direnvrc".text = ''
    # Additional direnv configuration can go here
  '';
}
