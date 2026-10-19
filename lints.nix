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

  hasAnyEnableOption =
    options: builtins.any (opt: lib.last opt.loc == "enable") (lib.collect lib.isOption options);
in
{
  config.assertions = map (
    path:
    let
      moduleOptions =
        (lib.evalModules {
          # Only the module's own option declarations matter, so don't complain about NixOS options it sets
          modules = [
            (import path)
            { _module.check = false; }
          ];
          specialArgs.pkgs = dummyPkgs;
        }).options;
    in
    {
      assertion = hasAnyEnableOption moduleOptions;
      message = "Module ${toString path} does not define any '*.enable' option.";
    }
  ) moduleFiles;
}
