{ pkgs, lib, inputs, ... }:

let
  zed-fhs = pkgs.buildFHSEnv {
    name = "zed-fhs";

    targetPkgs = pkgs: (with pkgs; [
      # Core Zed Editor
      inputs.zed.packages.${pkgs.system}.default

      # SSL/TLS support
      cacert
      openssl

      # Basic system libraries that downloaded binaries might need
      stdenv.cc.cc.lib
      zlib
      glibc

      # Common development tools
      git
      curl
      wget

      # Runtime libraries
      libgcc
      glib

      # X11/Wayland support
      xorg.libX11
      xorg.libXcursor
      xorg.libXrandr
      xorg.libXi
      xorg.libXext
      wayland

      # Audio (some language servers might need this)
      alsa-lib

      # Networking
      libressl
    ]);

    multiPkgs = pkgs: (with pkgs; [
      # 32-bit support for any needed libraries
      stdenv.cc.cc.lib
      zlib
      glib
    ]);

    runScript = "zeditor";

    profile = ''
      export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
      export NIX_SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
      export CURL_CA_BUNDLE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
    '';

    meta = with lib; {
      description = "Zed Editor in FHS environment with language server support";
      platforms = platforms.linux;
    };
  };
in
{
  environment.systemPackages = [ zed-fhs ];
}
