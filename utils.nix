{ lib, ... }:
let
  nixFilesIn =
    dir:
    let
      entries = builtins.readDir dir;
      isValidFile = name: type: type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix";
    in
    map (name: dir + "/${name}") (lib.attrNames (lib.filterAttrs isValidFile entries));
in
{
  inherit nixFilesIn;
}
