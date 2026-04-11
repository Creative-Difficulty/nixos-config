{ lib, ... }:
let
  entries = builtins.readDir ./.;
  fileNames = lib.attrNames entries;

  moduleImports = builtins.concatMap (
    name:
    let
      type = entries.${name};
      isImportable = type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix";
      tracedImportable =
        builtins.trace
          (
            if isImportable then
              "✅ Importing module ${name}"
            else
              "❌ Skipping module ${name} (type=${type})"
          )
          isImportable;
    in
    if tracedImportable then [ ./. + "/${name}" ] else [ ]
  ) fileNames;
in
{
  imports = moduleImports;
}
