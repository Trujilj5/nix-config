{
  description = "Centralized development shells for projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells =
          let shells = import ./i-console-dev.nix { inherit pkgs; };
          in {
            i-console-dev = shells.default;
            i-console-dev-fhs = shells.fhs;
          };


      });
}
