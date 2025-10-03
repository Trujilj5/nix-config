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

  home.file.".tmux/plugins/tmux-resurrect" = {
    source = pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-resurrect";
      rev = "v4.0.0";
      sha256 = "sha256-5Fh6MJkrbp+H3L8ePpXiflccZ/y2unRnAv7aJK8xS/U=";
    };
    recursive = true;
  };

  home.file.".tmux/plugins/tmux-continuum" = {
    source = pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-continuum";
      rev = "v3.1.0";
      sha256 = "sha256-nqa7hGG2V8FU/cWFU9mmCdifTTvgePwLwlCLVsQfHGw=";
    };
    recursive = true;
  };

  home.file.".config/tmux/tmux.conf".source = ../config/tmux/tmux.conf;
}
