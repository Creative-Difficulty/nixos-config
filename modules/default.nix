{ lib, ... }:
let
  entries = builtins.readDir ./.;
  fileNames = lib.attrNames entries;

  moduleImports = builtins.concatMap (
    name:
    let
      type = entries.${name};
      tracedImportable =
        builtins.trace
          (
            if type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix" then
              "✅ Importing module ${name}"
            else
              "❌ Skipping module ${name} (type=${type})"
          )
          (type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix");
    in
    if tracedImportable then [ ./. + "/${name}" ] else [ ]
  ) fileNames;
in
{
  imports = moduleImports;
}
