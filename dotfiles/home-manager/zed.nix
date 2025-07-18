# dotfiles/home-manager/zed.nix - Zed editor configuration
{ ... }:

{
  # Manage Zed configuration files
  home.file = {
    # Main settings file
    ".config/zed/settings.json".source = ../config/zed/settings.json;

    # Keymap configuration
    ".config/zed/keymap.json".source = ../config/zed/keymap.json;

    # Tasks configuration
    ".config/zed/tasks.json".source = ../config/zed/tasks.json;

    # Themes directory (if you have custom themes, add them here)
    # ".config/zed/themes/".source = ../config/zed/themes;
  };
}
