{ pkgs, ... }:

let
  username = builtins.getEnv "USER";
in
{
  programs.zsh.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" "dialout"];
  };


}
