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
    services.xserver.displayManager.sddm.enable = true;
  };
}
