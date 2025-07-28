{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    sddm.enable = lib.mkEnableOption "Whether to enable the SDDM display manager";
  };

  config = lib.mkIf config.sddm.enable {
    services.displayManager.sddm.enable = true;
    services.xserver.enable = true;
  };
}
