{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSEnv {
  name = "test-minimal";

  # Minimal packages for testing
  targetPkgs = pkgs: with pkgs; [
    bash
    coreutils
  ];

  # Minimal system libraries
  multiPkgs = pkgs: with pkgs; [
    glibc
  ];

  runScript = "bash";

  # Minimal profile
  profile = ''
    echo "📦 Minimal Test FHS Environment"
  '';
}).env
