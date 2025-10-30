{ lib, ... }:
let
  fileUtils = import ../utils.nix { inherit lib; };
in {
  imports = fileUtils.validFilesWith ./. (
    file:
      lib.hasSuffix ".nix" file
      && builtins.baseNameOf file != "default.nix"
      && !(lib.hasInfix "sddm-themes/" file)
  );
  traceIf true imports null
}
