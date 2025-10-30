{
  lib,
  config,
  pkgs,
  ...
}:
let
  fileUtils = import ../utils.nix { inherit lib; };

  validFiles =
    fileUtils.validFilesWith ./sddm-themes (
    file:
      lib.hasSuffix ".nix" file
  );
in
{
  trace validFiles null
  options = {
    sddm.enable = lib.mkEnableOption "Whether to enable the SDDM display manager";
  };

  config = lib.mkIf config.sddm.enable {
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.theme = "sugar-dark";
    services.xserver.enable = true;
#    services.displayManager.sddm.extraPackages = with pkgs; [ libsForQt5.qt5.qtgraphicaleffects ];
#    environment.systemPackages = map (file: pkgs.callPackage file { }) validFiles;
#environment.systemPackages = map (file: import file { inherit (pkgs) lib stdenv fetchFromGitHub; }) validFiles;
environment.systemPackages = map (path: pkgs.callPackage path { }) packagePaths;
  };
}
