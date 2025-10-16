{ pkgs, ... }:
{
  programs.zsh.enable = true;

  users.users.john = {
    isNormalUser = true;
    description = "john";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker"]; 
  };


}
