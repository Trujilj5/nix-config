{ config, pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Ensure direnv loads nix-direnv properly
  home.file.".config/direnv/direnvrc".text = ''
    # Load nix-direnv for better nix support
    source_env_if_exists "${pkgs.nix-direnv}/share/nix-direnv/direnvrc"
  '';
}
