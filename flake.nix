{
  description = "Alex' (beginnner) NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko, home-manager, sops-nix, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {    
    nixosConfigurations = {
      nixosbtw = nixpkgs.lib.nixosSystem {
        inherit system;
        # Give the configuration access to inputs of the flake and outputs
        specialArgs = { inherit inputs; };
        modules = [
          disko.nixosModules.disko
          #sops-nix.nixosModules.sops

          ./hosts/nixosbtw/hardware-configuration.nix
          ./hosts/nixosbtw/configuration.nix
        ];
      }; # nixosbtw
    }; # nixosconfigurations

    homeConfigurations."alex" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [ ./users/alex.nix ];
      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
      extraSpecialArgs = { inherit inputs; };
    };
  }; # let ... in ...
}

