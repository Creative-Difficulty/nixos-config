{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  options = {
    yazi.enable = lib.mkEnableOption "Whether to install yazi";
    yazi.bleedingEdge = lib.mkEnableOption "Whether to to build yazi from the latest GitHub commit";
    yazi.shellWrapper = lib.mkEnableOption "Whether to enable the bash/Zsh wrapper";
    yazi.shellWrapperName = lib.mkOption {
      type = lib.types.str;
      default = "y";
      description = "Name of the shell wrapper function";
    };
  };

  config = lib.mkIf config.yazi.enable (
    let
      yaziConfigPath = ../../../dotfiles/yazi.toml;
      bashZshShellWrapper = import ./shellWrapper.nix {
        inherit pkgs;
        wrapperName = config.yazi.shellWrapperName;
      };
    in
    (lib.mkMerge [
      (lib.mkIf config.yazi.bleedingEdge {
        home.file.".config/yazi/yazi.toml".source = yaziConfigPath;
        home.packages = [
          inputs.yazi.packages.${pkgs.system}.default
          pkgs.file
        ];

        home.file.".bashrc".text = ''${bashZshShellWrapper}'';
      })

      (lib.mkIf (!config.yazi.bleedingEdge) {
        programs.yazi = {
          enable = true;
          settings = builtins.fromTOML (builtins.readFile yaziConfigPath);
          enableBashIntegration = config.yazi.shellWrapper;
        };
        home.file.".bashrc".text = ''${bashZshShellWrapper}'';
      })

    ])
  );
}
