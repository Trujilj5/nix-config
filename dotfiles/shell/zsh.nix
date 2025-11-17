{ pkgs, ... }:
{
  programs.zsh.enable = true;

  users.users.martyt = {
    isNormalUser = true;
    description = "martyt";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" "dialout"];
  };


}
