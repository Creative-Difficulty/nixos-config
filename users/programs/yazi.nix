{ lib, config, inputs, pkgs, ... }: {
  options = {
    yazi.enable = lib.mkEnableOption "Whether to install yazi";
    yazi.bleedingEdge = lib.mkEnableOption "Whether to to build yazi from the latest GitHub commit";
  };

  config = lib.mkIf config.yazi.enable {

    lib.mkIf config.yazi.bleedingEdge.enable {
      home.file.".config/yazi/yazi.toml".source = ../dotfiles/yazi.toml;
      home.packages = old: old ++ [
        inputs.yazi.packages.${pkgs.system}.default

        # yazi dependency?
        pkgs.file
      ];
    }

    lib.mkIf !config.yazi.bleedingEdge.enable {
      # QUESTION: How to know if this is being installed by home manager or just nix
      programs.yazi = {
        enable = true;
        settings = builtins.fromTOML (builtins.readFile ../dotfiles/yazi.toml);
      };
    }
  };
}
