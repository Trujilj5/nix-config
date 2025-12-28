{ config, ... }:

{
  home.file = {
    ".config/zed/settings.json".source = config.lib.file.mkOutOfStoreSymlink "/home/john/nixos/dotfiles/config/zed/settings.json";
    ".config/zed/keymap.json".source = config.lib.file.mkOutOfStoreSymlink "/home/john/nixos/dotfiles/config/zed/keymap.json";
    ".config/zed/tasks.json".source = config.lib.file.mkOutOfStoreSymlink "/home/john/nixos/dotfiles/config/zed/tasks.json";
  };
}
