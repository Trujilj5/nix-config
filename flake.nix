{
  description = "My NixOS Flake";

  inputs = {
    # Nixpkgs Flakes
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 3rd Party Flakes
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, zen-browser, ... }@inputs:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        inputs.home-manager.nixosModules.default
        {
          home-manager = {
            extraSpecialArgs = { inherit inputs; };
            backupFileExtension = "backup";
            users = {
              john = import ./home.nix;
            };
          };
        }
        ({ config, pkgs, inputs, ... }: {
          environment.systemPackages = [
            inputs.zen-browser.packages.${system}.default
          ];
          _module.args = {
            unstablePkgs = import inputs.nixpkgs-unstable {
              inherit system;
              config = config.nixpkgs.config;
            };
          };
        })
      ];
    };
  };
}
