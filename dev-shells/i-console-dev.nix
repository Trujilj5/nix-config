{ pkgs ? import <nixpkgs> {} }: let
  deps = (with pkgs; [
    bun
    nodejs_24
    tsx
    typescript
    gcc
    gnumake
    python3
    pkg-config
  ]);
in
{
  default = pkgs.mkShell {
    name = "i-console-dev";
    buildInputs = deps;
  };

  fhs = pkgs.buildFHSEnv {
    name = "i-console-dev-fhs";
    targetPkgs = pkgs: (with pkgs; [
      # Only packages that specifically need FHS
      bun
      nodejs_24
    ]);
    multiPkgs = pkgs: (with pkgs; [
      # Only system libraries needed for dynamic linking
      glibc
      libgcc
      stdenv.cc.cc.lib
      openssl
      zlib
    ]);
    runScript = "zsh";
  };
}
