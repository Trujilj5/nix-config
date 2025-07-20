{ pkgs, ... }:

{
  home.packages = with pkgs; [
    tmux
    tmux-sessionizer
  ];

  home.file.".tmux/plugins/tpm" = {
    source = pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tpm";
      rev = "v3.1.0";
      sha256 = "sha256-CeI9Wq6tHqV68woE11lIY4cLoNY8XWyXyMHTDmFKJKI=";
    };
    recursive = true;
  };

  home.file.".config/tmux/tmux.conf".source = ../config/tmux/tmux.conf;
}
