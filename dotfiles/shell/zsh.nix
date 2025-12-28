{ pkgs, systemUser, ... }:

{
  programs.zsh.enable = true;

  users.users.${systemUser} = {
    isNormalUser = true;
    description = systemUser;
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" "dialout"];
  };


}
