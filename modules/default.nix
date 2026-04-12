{ lib, ... }:
let
  entries = builtins.readDir ./.;
  fileNames = lib.attrNames entries;

  moduleImports = builtins.concatMap (
    name:
    let
      type = entries.${name};
      isImportable = type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix";
      traceMessage =
        if isImportable then
          "✅ Importing module ${name}"
        else
          "❌ Skipping module ${name} (type=${type})";
      tracedImportable =
        builtins.trace traceMessage isImportable;
    in
    if tracedImportable then [ (./. + "/${name}") ] else [ ]
  ) fileNames;
in
{
  imports = moduleImports;
}
