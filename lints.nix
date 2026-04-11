{ lib, ... }:
let
  fileUtils = import ./utils.nix { inherit lib; };
  moduleFiles = fileUtils.nixFilesIn ./modules;

  hasEnableOption =
    options:
    builtins.any (path: lib.last path == "enable") (lib.attrNamesRecursive options);
in
{
  config.assertions = map (
    path:
    let
      mod = import path;
      moduleOptions = (lib.evalModules {
        modules = [ mod ];
        specialArgs.pkgs = { };
      }).options;
    in
    {
      assertion = hasEnableOption moduleOptions;
      message = "Module ${toString path} does not define any '*.enable' option.";
    }
  ) moduleFiles;
}
