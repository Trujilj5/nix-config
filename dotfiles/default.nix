# dotfiles/default.nix - Central import for all dotfile configurations
{ config, pkgs, lib, ... }:

{
  imports = [
    ./shell/zsh.nix
    # Add more system-level dotfile configs here as you create them
    # ./shell/bash.nix
    # ./network/ssh.nix
    # ./services/docker.nix
  ];
}
