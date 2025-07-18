# dotfiles/home-manager/tmux.nix - Tmux terminal multiplexer configuration
{ pkgs, ... }:

{
  # Useful Tmux-related packages
  home.packages = with pkgs; [
    tmux
    tmux-sessionizer
  ];

  # Install TPM (Tmux Plugin Manager)
  home.file.".tmux/plugins/tpm" = {
    source = pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tpm";
      rev = "v3.1.0";
      sha256 = "sha256-CeI9Wq6tHqV68woE11lIY4cLoNY8XWyXyMHTDmFKJKI=";
    };
    recursive = true;
  };

  # Use plain config file instead of home-manager tmux program
  home.file.".config/tmux/tmux.conf".source = ../config/tmux/tmux.conf;
}
