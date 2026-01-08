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
          mesa.drivers
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
          playwright = (pkgs.buildFHSEnv {
            name = "playwright-env";
            targetPkgs = pkgs: (with pkgs; [
              nodejs
              bun
            ] ++ playwrightDeps);

            runScript = "zsh";

            profile = ''
              export PLAYWRIGHT_BROWSERS_PATH=$HOME/.cache/ms-playwright
              export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=0

              echo "✓ Playwright development environment (FHS)"
              echo ""
              echo "First time setup:"
              echo "  npx playwright install chromium    - Install Chromium browser"
              echo ""
              echo "Commands:"
              echo "  bun run test                                        - Run all tests"
              echo "  bun run test tests/keycloak-integration.spec.ts    - Run specific test"
              echo "  bun run test:ui                                     - Run tests in UI mode"
            '';
          }).env;
        };
      }
    );
}
