{ lib, ... }:
let
  fileUtils = import ./utils.nix { inherit lib; };
  moduleFiles = fileUtils.nixFilesIn ./modules;

  dummyPkgs =
    let
      self = {
        callPackage = path: _: import path self;
        libsForQt5.qt5.qtgraphicaleffects = null;
      };
    in
    self;

  hasEnableOption =
    options:
    builtins.any (path: lib.last path == "enable") (lib.attrNamesRecursive options);
in
{
  config.assertions = map (
    path:
    let
      moduleOptions = (lib.evalModules {
        modules = [ (import path) ];
        specialArgs.pkgs = dummyPkgs;
      }).options;
    in
    {
      assertion = hasEnableOption moduleOptions;
      message = "Module ${toString path} does not define any '*.enable' option.";
    }
  ) moduleFiles;
}
