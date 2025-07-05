# /etc/nixos/dotfiles/shell/zsh.nix
{ config, pkgs, ... }:
{
  # Enable zsh system-wide
  programs.zsh.enable = true;

  users.users.john = {
    isNormalUser = true;
    description = "john";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  users.defaultUserShell = pkgs.zsh;
}
