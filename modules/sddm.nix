{
  lib,
  config,
  pkgs,
  ...
}:
let
  # Recursively constructs an attrset of a given folder, recursing on directories, value of attrs is the filetype
  getDir =
    dir:
    mapAttrs (file: type: if type == "directory" then getDir "${dir}/${file}" else type) (
      builtins.readDir dir
    );

  # Collects all files of a directory as a list of strings of paths
  files =
    dir: collect isString (mapAttrsRecursive (path: type: concatStringsSep "/" path) (getDir dir));

  # Filters out directories that don't end with .nix or are this file, also makes the strings absolute
  validFiles =
    dir:
    map (file: ./. + "/${file}") (
      filter (file: hasSuffix ".nix" file && file != "default.nix" && builtins.match ".*sddm-themes/.*" file == null) (
        files dir
      )
    );

in
{
  options = {
    sddm.enable = lib.mkEnableOption "Whether to enable the SDDM display manager";
  };

  config = lib.mkIf config.sddm.enable {
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.theme = "sugar-dark";
    services.xserver.enable = true;
#    services.displayManager.sddm.extraPackages = with pkgs; [ libsForQt5.qt5.qtgraphicaleffects ];
    environment.systemPackages = [
      (pkgs.callPackage validFiles ./sddm-themes { })
    ];
  };
}
