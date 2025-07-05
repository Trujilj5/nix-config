# dotfiles/home-manager/tmux.nix - Tmux terminal multiplexer configuration
{ config, pkgs, ... }:

{
  # Useful Tmux-related packages
  home.packages = with pkgs; [
    tmux-sessionizer
  ];
  
  # Install TPM (Tmux Plugin Manager)
  home.file.".tmux/plugins/tpm" = {
    source = pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tpm";
      rev = "v3.1.0";
      sha256 = "sha256-CeI9Wq6tHqV68woE11lIY4cLotwORWD+bcwZOSFaLxs=";
    };
    recursive = true;
  };

  # Enable and configure Tmux
  programs.tmux = {
    enable = true;
    clock24 = true;
    
    # TPM configuration will be handled in tmux.conf
    
    # Custom configuration from file
    extraConfig = builtins.readFile ../config/tmux/tmux.conf;
  };
}