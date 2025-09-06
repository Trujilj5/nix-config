{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSEnv {
  name = "i-console-dev";

  # Packages available in the FHS environment
  targetPkgs = pkgs: with pkgs; [
    # Core Runtime
    bun
    nodejs_24

    # Development Tools
    tsx
    typescript
  ];

  # Libraries that need to be available in both 32-bit and 64-bit
  multiPkgs = pkgs: with pkgs; [
    # System Libraries (for dynamically linked binaries)
    glibc
    libgcc
    stdenv.cc.cc.lib

    # Build Tools (for native modules)
    gcc
    gnumake
    python3
    pkg-config

    # Additional Libraries (common dependencies)
    openssl
    zlib
  ];

  runScript = "zsh";

  # Set up FHS environment variables
  profile = ''
    # Mark that we're in an FHS environment to prevent direnv loops
    export IN_FHS_SHELL=1
  '';
}).env
