{ pkgs, config, ... }:

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
      sha256 = "sha256-44Ok7TbNfssMoBmOAqLLOj7oYRG3AQWrCuLzP8tA8Kg=";
    };
    recursive = true;
  };

  home.file.".tmux/plugins/tmux-continuum" = {
    source = pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-continuum";
      rev = "v3.1.0";
      sha256 = "sha256-e02cshLR9a2+uhrU/oew+FPTKhd4mi0/Q02ToHbbVrE=";
    };
    recursive = true;
  };

  home.file.".config/tmux/plugins/tmux" = {
    source = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "tmux";
      rev = "v2.1.2";
      sha256 = "sha256-vBYBvZrMGLpMU059a+Z4SEekWdQD0GrDqBQyqfkEHPg=";
    };
    recursive = true;
  };

  home.file.".config/tmux/tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/dotfiles/config/tmux/tmux.conf";
}
