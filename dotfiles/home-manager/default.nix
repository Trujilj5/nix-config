{ ... }:

{
  imports = [
    ./zsh.nix
    ./hyprland.nix
    ./waybar.nix
    ./wofi.nix
    ./zed.nix
    ./nvim.nix
    ./ghostty.nix
    ./tmux.nix
    ./zen-browser.nix
    ./lazygit.nix
    ./lazysql.nix
    # ./direnv.nix  # Disabled to avoid conflicts with system config
  ];
}
