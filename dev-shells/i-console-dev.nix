{ pkgs }:

pkgs.buildFHSUserEnv {
  name = "i-console-dev";
  targetPkgs = pkgs: with pkgs; [
    # Core Runtime
    bun
    nodejs_24
    
    # Development Tools
    tsx
    typescript
    
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
}