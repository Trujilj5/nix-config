{
  description = "My NixOS Flake";

  inputs = {
    # Nixpkgs Flakes
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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

    # 3rd Party Flakes
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    # # Zed Editor (pinned to avoid frequent rebuilds)
    # zed.url = "github:zed-industries/zed/v0.204.5";
    # zed.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, stylix, determinate, nvf, ... }@inputs:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        determinate.nixosModules.default
        inputs.home-manager.nixosModules.default
        stylix.nixosModules.stylix
        {
          nixpkgs.config.allowUnfree = true;
          home-manager = {
            extraSpecialArgs = { inherit inputs; };
            backupFileExtension = "backup";
            users = {
              john = import ./home.nix;
            };
            sharedModules = [ nvf.homeManagerModules.default ];
            useGlobalPkgs = true;
            useUserPackages = true;
          };
          stylix.enableReleaseChecks = false;
        }
        # ./zed-fhs.nix
        ({ config, inputs, ... }: {
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
