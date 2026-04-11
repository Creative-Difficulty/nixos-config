{
  lib,
  config,
  pkgs,
  ...
}:
let
  themeWrapper = import ./sddm-themes/default.nix { inherit lib pkgs; };
in
{
  options = {
    sddm.enable = lib.mkEnableOption "Whether to enable the SDDM display manager";
    sddm.theme = lib.mkOption {
      type = lib.types.enum (builtins.attrNames themeWrapper.themes);
      default = "sugar-dark";
      description = "The SDDM theme to enable.";
    };
  };

  config = lib.mkIf config.sddm.enable {
    services.displayManager.sddm.enable = true;
    environment.systemPackages = [ themeWrapper.themes.${config.sddm.theme} ];
    services.displayManager.sddm.extraPackages = with pkgs; [ libsForQt5.qt5.qtgraphicaleffects ];
    services.displayManager.sddm.theme = config.sddm.theme;
    services.xserver.enable = true;
  };
}
