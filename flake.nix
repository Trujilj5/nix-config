{
  description = "My NixOS Flake";

  inputs = {
    # Nixpkgs Flakes
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # Winboat flake from upstream repo
    winboat.url = "github:TibixDev/winboat/9e4f0b7eb3807e337d4015da126ae52f64c570d3";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Theming
    stylix = {
      url = "github:nix-community/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # # Zed Editor (pinned to avoid frequent rebuilds)
    # zed.url = "github:zed-industries/zed/v0.204.5";
    # zed.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, stylix, determinate, nvf, ... }@inputs:
  let
    system = "x86_64-linux";
  in {
    homeConfigurations.john = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      extraSpecialArgs = { inherit inputs; };
      modules = [
        ./home.nix
        nvf.homeManagerModules.default
        stylix.homeManagerModules.stylix
      ];
    };

    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        determinate.nixosModules.default
        stylix.nixosModules.stylix
        {
          nixpkgs.config.allowUnfree = true;
          stylix.enableReleaseChecks = false;
        }
        # ./zed-fhs.nix
        ({ config, inputs, ... }: {
          _module.args = {
            unstablePkgs = import inputs.nixpkgs-unstable {
              inherit system;
              config = config.nixpkgs.config;
              overlays = [
                (final: prev: {
                  # Override winboat with version from upstream flake
                  winboat = inputs.winboat.packages.${system}.winboat;
                })
              ];
            };
          };
        })
      ];
    };
  };
}
