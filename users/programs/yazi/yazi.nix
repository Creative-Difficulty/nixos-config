{ lib, config, inputs, pkgs, ... }: {
  options = {
    yazi.enable = lib.mkEnableOption "Whether to install yazi";
    yazi.bleedingEdge = lib.mkEnableOption "Whether to to build yazi from the latest GitHub commit";
    yazi.shellWrapper = lib.mkEnableOption "Whether to enable the bash/Zsh wrapper";
  };

  config = lib.mkIf config.yazi.enable (
    let
      yaziConfigPath = ../../../dotfiles/yazi.toml;
      bashShellWrapper = import ./shellWrapper.nix;
    in (
      lib.mkMerge [
        (lib.mkIf config.yazi.bleedingEdge {
          home.file.".config/yazi/yazi.toml".source = yaziConfigPath;
          home.packages = [
            inputs.yazi.packages.${pkgs.system}.default
            pkgs.file
          ];

          home.file.".bashrc".text = ''${bashShellWrapper}'';
        })

        (lib.mkIf (!config.yazi.bleedingEdge) {
          programs.yazi = {
            enable = true;
            settings = builtins.fromTOML (builtins.readFile yaziConfigPath);
            # enableBashIntegration = true;
          };
          home.file.".bashrc".text = ''${bashShellWrapper}'';
          # home.file.".bashrc".text = ''
          
          # '';

        })
        
      ]
    )
  );
}
