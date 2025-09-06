{ pkgs ? import <nixpkgs> {} }: let
  deps = (with pkgs; [
    bun
    nodejs_24
    tsx
    typescript
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
      bun
      nodejs_24
    ]);
    multiPkgs = pkgs: (with pkgs; [
      glibc
      libgcc
      stdenv.cc.cc.lib
      openssl
      zlib
      gcc
      gnumake
      python3
      pkg-config
    ]);
    runScript = "zsh";
  };
}
