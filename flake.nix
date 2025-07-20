{
  description = "My NixOS Flake";

  inputs = {
    # Nixpkgs Flakes
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Theming
    stylix = {
      url = "github:nix-community/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 3rd Party Flakes
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, stylix, zen-browser, ... }@inputs:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        inputs.home-manager.nixosModules.default
        stylix.nixosModules.stylix
        {
          home-manager = {
            extraSpecialArgs = { inherit inputs; };
            backupFileExtension = "backup";
            users = {
              john = import ./home.nix;
            };
          };
          stylix.enableReleaseChecks = false;
        }
        ({ config, inputs, ... }: {
          environment.systemPackages = [
            inputs.zen-browser.packages.${system}.default
            inputs.nixpkgs-unstable.legacyPackages.${system}.zed-editor-fhs
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
