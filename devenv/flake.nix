{
  description = "Centralized development environments";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Playwright browser dependencies
        playwrightDeps = with pkgs; [
          glib
          nspr
          nss
          dbus
          atk
          at-spi2-atk
          expat
          libdrm
          xorg.libX11
          xorg.libXcomposite
          xorg.libXdamage
          xorg.libXext
          xorg.libXfixes
          xorg.libXrandr
          mesa
          libxkbcommon
          systemd
          alsa-lib
          cairo
          pango
          gtk3
          gdk-pixbuf
          freetype
          fontconfig
          cups
          udev
          libnotify
          xorg.libxcb
          xorg.libxshmfence
        ];

        playwrightLibPath = pkgs.lib.makeLibraryPath playwrightDeps;

      in
      {
        devShells = {
          # Playwright environment for projects
          playwright = pkgs.mkShell {
            buildInputs = with pkgs; [
              nodejs
              bun
              playwright-driver.browsers
            ] ++ playwrightDeps;

            shellHook = ''
              export PLAYWRIGHT_BROWSERS_PATH=${pkgs.playwright-driver.browsers}
              export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true
              export LD_LIBRARY_PATH=${playwrightLibPath}:$LD_LIBRARY_PATH

              echo "✓ Playwright development environment (NixOS-compatible browsers)"
              echo ""
              echo "Commands:"
              echo "  bun run test                                        - Run all tests"
              echo "  bun run test tests/keycloak-integration.spec.ts    - Run specific test"
              echo "  bun run test:ui                                     - Run tests in UI mode"
            '';
          };
        };
      }
    );
}
