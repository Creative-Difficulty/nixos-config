{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:

let
  bashZshShellWrapper = import ./shellWrapper.nix {
    inherit pkgs;
    wrapperName = config.yazi.shellWrapperName;
  };

  shellExtras = lib.mkMerge [
    (lib.mkIf config.yazi.enableShellWrapper {
      home.file.".bashrc".text = ''${bashZshShellWrapper}'';
    })
    (lib.mkIf config.yazi.enableCommandAlias {
      home.file.".bashrc".text = ''
        ${config.yazi.commandAlias}() {
          yazi "$@"
        }
      '';
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

    yazi.configFilePath = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = ../../../dotfiles/yazi.toml;
      description = "Path to a yazi.toml. If null, no config is deployed and yazi's defaults apply.";
    };
  };

  config = lib.mkIf config.yazi.enable (
    lib.mkMerge [
      (lib.mkIf config.yazi.bleedingEdge {
        home.packages = [
          inputs.yazi.packages.${pkgs.system}.default
          # TODO: Why is this dependency required?
          pkgs.file
        ];
      })

      (lib.mkIf (!config.yazi.bleedingEdge) {
        programs.yazi = {
          enable = true;
          enableBashIntegration = config.yazi.enableShellWrapper;
          settings = lib.mkIf (config.yazi.configFilePath != null) (
            builtins.fromTOML (builtins.readFile config.yazi.configFilePath)
          );
        };
      })

      shellExtras
    ]
  );
}
