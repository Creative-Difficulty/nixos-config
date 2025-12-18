{ lib, pkgs, ... }:

let
  fileUtils = import ../../utils.nix { inherit lib; };

  validFiles =
    fileUtils.validFilesWith ./sddm-themes (
      file:
        let
          rel = lib.removePrefix (toString ./. + "/") (toString file);
          ok = lib.hasSuffix ".nix" rel && builtins.baseNameOf rel != "default.nix";
        in
          builtins.trace "Checking theme file: ${rel} → valid = ${toString ok}" ok
    );

  themes = builtins.listToAttrs (map (file: {
    name = lib.removeSuffix ".nix" (builtins.baseNameOf file);
    value = pkgs.callPackage file { };
  }) validFiles);

in
{
  inherit themes;

  # Helper: get theme derivations as a list
  allThemes = builtins.attrValues themes;
}
