{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    ghostty
  ];

  home.file = {
    ".config/ghostty/config".source = config.lib.file.mkOutOfStoreSymlink "/home/john/nixos/dotfiles/config/ghostty/config";
  };
}
