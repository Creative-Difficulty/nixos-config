{ lib, config, inputs, pkgs, ... }: {
  options = {
    yazi.enable = lib.mkEnableOption "Whether to install yazi";
    yazi.bleedingEdge = lib.mkEnableOption "Whether to to build yazi from the latest GitHub commit";
  };

  config = lib.mkIf config.yazi.enable (
    let
      yaziConfigPath = ../../dotfiles/yazi.toml;
    in
    lib.mkMerge [
      (lib.mkIf config.yazi.bleedingEdge {
        home.file.".config/yazi/yazi.toml".source = yaziConfigPath;
        home.packages = oldPkgs: oldPkgs ++ [
          inputs.yazi.packages.${pkgs.system}.default
          pkgs.file
        ];
      })

      (lib.mkIf (!config.yazi.bleedingEdge) {
        programs.yazi = {
          enable = true;
          settings = builtins.fromTOML (builtins.readFile yaziConfigPath);
        };
      })
    ]
  );
}
