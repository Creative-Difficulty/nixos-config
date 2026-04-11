{ lib, pkgs, ... }:
let
  fileUtils = import ../../utils.nix { inherit lib; };

  themes = builtins.listToAttrs (
    map (file: {
      name = lib.removeSuffix ".nix" (builtins.baseNameOf file);
      value = pkgs.callPackage file { };
    }) (fileUtils.nixFilesIn ./.)
  );
in
{
  inherit themes;

  # Helper: get theme derivations as a list
  allThemes = builtins.attrValues themes;
}
