{ lib, ... }:
let
  fileUtils = import ../utils.nix { inherit lib; };

  imports' = fileUtils.validFilesWith ./. (
    file:
      let
        rel = lib.removePrefix (toString ./. + "/") (toString file);
        _ = builtins.trace "🔍 Found file: ${rel}" null;
        ok =
          lib.hasSuffix ".nix" rel
          && builtins.baseNameOf rel != "default.nix"
          && !(lib.hasPrefix "sddm-themes/" rel);
        __ = if ok
          then builtins.trace "✅ Importing ${rel}" null
          else builtins.trace "❌ Skipping ${rel}" null;
      in
        ok
  );
in {
  imports = imports';
}
