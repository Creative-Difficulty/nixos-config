{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:

let
  yaziConfigPath = ../../../dotfiles/yazi.toml;

  bashZshShellWrapper = import ./shellWrapper.nix {
    inherit pkgs;
    wrapperName = config.yazi.shellWrapperName;
  };

  shellExtras = lib.mkMerge [
    (lib.mkIf config.yazi.enableShellWrapper {
      home.file.".bashrc".text = ''${bashZshShellWrapper}'';
    })
    (lib.mkIf config.yazi.enableCommandAlias {
      home.file.".bashrc".text = ''alias ${config.yazi.commandAlias}="yazi"'';
    })
  ];
in
{
  options = {
    yazi.enable = lib.mkEnableOption "Whether to install yazi";
    yazi.bleedingEdge = lib.mkEnableOption "Whether to build yazi from the latest GitHub commit";

    yazi.enableShellWrapper = lib.mkEnableOption "Whether to enable the bash/Zsh wrapper";
    yazi.shellWrapperName = lib.mkOption {
      type = lib.types.str;
      default = "yy";
      description = "Name of the shell wrapper function";
    };

    yazi.enableCommandAlias = lib.mkEnableOption "Whether to alias the `yazi` command to something else";
    yazi.commandAlias = lib.mkOption {
      type = lib.types.str;
      default = "y";
      description = "Alias for the `yazi` command (without the shell wrapper)";
    };
  };

  config = lib.mkIf config.yazi.enable (
    lib.mkMerge [
      (lib.mkIf config.yazi.bleedingEdge {
        home.file.".config/yazi/yazi.toml".source = yaziConfigPath;
        home.packages = [
          inputs.yazi.packages.${pkgs.system}.default
          pkgs.file
        ];
      })

      (lib.mkIf (!config.yazi.bleedingEdge) {
        programs.yazi = {
          enable = true;
          settings = builtins.fromTOML (builtins.readFile yaziConfigPath);
          enableBashIntegration = config.yazi.enableShellWrapper;
        };
      })

      shellExtras
    ]
  );
}
