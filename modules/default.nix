{ lib, ... }:
let
  fileUtils = import ../utils.nix { inherit lib; };
in {
  imports = fileUtils.validFilesWith ./. (
    file:
      lib.hasSuffix ".nix" file
      && lib.baseNameOf file != "default.nix"
      && builtins.match ".*sddm-themes/.*" file == null
  );
}