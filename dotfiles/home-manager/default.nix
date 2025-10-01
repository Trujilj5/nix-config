{ ... }:

{
  imports = [
    ./zsh.nix
    ./hyprland.nix
    ./waybar.nix
    ./wofi.nix
    ./zed.nix
    # ./nvim.nix  # Temporarily disabled to test conflict
    ./ghostty.nix
    ./tmux.nix
    ./zen-browser.nix
    ./lazygit.nix
    ./lazysql.nix
    ./yazi.nix
  ];
}
