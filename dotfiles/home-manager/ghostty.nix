{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    ghostty
  ];

  home.file = {
    ".config/ghostty/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/dotfiles/config/ghostty/config";
  };
}
