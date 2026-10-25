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

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-code.url = "github:sadjow/claude-code-nix";

    # No nixpkgs follows: its fixed-output node_modules hash depends on the pinned bun
    slick.url = "github:3kh0/slick";

    ragenix = {
      url = "github:yaxitech/ragenix";
      # optional, not necessary for the module
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
      # optionally choose not to download darwin deps (saves some resources on Linux, produces a warning, because for some reason ragenix doesn't pass through the darwin module from agenix even though they say they do)
      # inputs.darwin.follows = "";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    (
      let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        nixosConfigurations = {
          nixosbtw = nixpkgs.lib.nixosSystem {
            inherit system;
            # Give the configuration access to inputs of the flake and outputs
            specialArgs = { inherit inputs; };
            modules = [
              ./hosts/nixosbtw/hardware-configuration.nix
              ./hosts/nixosbtw/configuration.nix
            ];
          }; # nixosbtw
        }; # nixosconfigurations
        # Why is this alex and can't be config.vars.mainUser?
        homeConfigurations."alex" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [
            ./users/alex.nix
            inputs.ragenix.homeManagerModules.default
          ];

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
          extraSpecialArgs = { inherit inputs; };
        };

        formatter.${system} = pkgs.nixfmt-tree;

        devShells.${system}.stress =
          let
            # unfree.nix is a NixOS module and doesn't apply here
            stressPkgs = import nixpkgs {
              inherit system;
              config.allowUnfreePredicate = pkg: nixpkgs.lib.getName pkg == "furmark";
            };
          in
          stressPkgs.mkShell {
            name = "stress";
            packages = with stressPkgs; [
              stress-ng
              furmark
              vulkan-tools
              xrdb

              (writeShellScriptBin "stress-cpu" ''
                stress-ng --cpu 0 --vm 2 --vm-bytes 75% -t 15m "$@"
              '')
              (writeShellScriptBin "stress-gpu" ''
                # FurMark segfaults under Xwayland if no X resources are set
                xrdb -query | grep -q . || echo "Xft.dpi: 96" | xrdb -merge
                furmark --demo furmark-vk --width 1920 --height 1080 --max-time 900 --no-score-box "$@"
              '')
            ];
          };
      } # let ... in ...
    );
}
