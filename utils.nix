# Partly taken from: https://github.com/evanjs/nixos_cfg/blob/master/config/new-modules/default.nix
{ lib, ... }:
with lib;
let
  getDir =
    dir:
    mapAttrs (file: type: if type == "directory" then getDir "${dir}/${file}" else type) (
      builtins.readDir dir
    );

  files =
    dir: collect isString (mapAttrsRecursive (path: type: concatStringsSep "/" path) (getDir dir));

  validFilesWith =
    dir: filterFn:
      map (file: ./. + "/${file}") (
        filter filterFn (files dir)
      );
in {
  inherit validFilesWith;
}
