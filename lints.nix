{ lib, ... }:
let
  fileUtils = import ./utils.nix { inherit lib; };
  moduleFiles = fileUtils.nixFilesIn ./modules;

  definesEnableOption =
    path:
    builtins.match "(?s).*\\.enable\\s*=\\s*lib\\.mkEnableOption.*" (builtins.readFile path) != null;
in
{
  config.assertions = map (
    path:
    {
      assertion = definesEnableOption path;
      message = "Module ${toString path} does not define any '*.enable' option.";
    }
  ) moduleFiles;
}
