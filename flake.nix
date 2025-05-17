{
  description = "Alex' (beginner) NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yazi.url = "github:sxyazi/yazi";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ragenix = {
      url = "github:yaxitech/ragenix";
      # optional, not necessary for the module
      inputs.nixpkgs.follows = "nixpkgs";
      # optionally choose not to download darwin deps (saves some resources on Linux, produces a warning, because for some reason ragenix doesn't pass through the darwin module from agenix even though they say they do)
      # inputs.darwin.follows = "";
    };
  };

  outputs = { self, nixpkgs, disko, home-manager, ragenix, yazi, ... }@inputs: (
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {    
      nixosConfigurations = {
        nixosbtw = nixpkgs.lib.nixosSystem {
          inherit system;
          # Give the configuration access to inputs of the flake and outputs
          # specialArgs = { inherit inputs; };
          modules = [
            disko.nixosModules.disko

            {
              environment.systemPackages = [ ragenix.packages.${system}.default ];
            }

            ./hosts/nixosbtw/hardware-configuration.nix
            ./hosts/nixosbtw/configuration.nix
          ];
        }; # nixosbtw
      }; # nixosconfigurations

      homeConfigurations."alex" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./users/alex.nix
          ragenix.homeManagerModules.default
        ];
        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        # extraSpecialArgs = { ragenix = inputs.ragenix.homeManager; };
      };
    } # let ... in ...
  );
}

