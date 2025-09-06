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

  runScript = "bash";

  # Set up FHS environment variables
  profile = ''
    # Use bash to avoid zsh config loops with direnv
    export SHELL="$(command -v bash)"
  '';
}).env
