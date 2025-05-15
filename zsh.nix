# /etc/nixos/zsh.nix
{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    ohMyZsh.enable = true;
  };

  users.users.john = {
    isNormalUser = true;
    description = "john";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    zsh-powerlevel10k
    zsh-autosuggestions
    zsh-completions
  ];
}
