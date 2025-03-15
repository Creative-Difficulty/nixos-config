{
  description = "Alex' (beginnner) NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # deploy-rs.url = "github:serokell/deploy-rs";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  # outputs = { self, nixpkgs, disko, deploy-rs, ... }@inputs: {
  outputs = { self, nixpkgs, disko, ... }@inputs: {
    nixosConfigurations = {
      nixosbtw = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # Give the configuration access to inputs of the flake and outputs?
        specialArgs = { inherit inputs self; };
        modules = [
          disko.nixosModules.disko
          ./hosts/nixosbtw/hardware-configuration.nix

          ./hosts/nixosbtw/configuration.nix
          inputs.home-manager.nixosModules.default
        ];

      };
      
      # deploy.nodes.nixosbtw = {
      #   hostname = "nixosbtw";
      #   profiles.system = {
      #     user = "root";
      #     path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.nixosbtw;
      #   };
      # };

      # This is highly advised, and will prevent many possible mistakes
      # checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
  };
}

