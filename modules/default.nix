{ lib, ... }:
let
  entries = builtins.readDir ./.;
  fileNames = lib.attrNames entries;

  imports' = builtins.concatMap (
    name:
    let
      type = entries.${name};
      isImportable = type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix";
      _ =
        builtins.trace
          (
            if isImportable then
              "✅ Importing module ${name}"
            else
              "❌ Skipping module ${name} (type=${type})"
          )
          null;
    in
    if isImportable then [ ./. + "/${name}" ] else [ ]
  ) fileNames;
in
{
  imports = imports';
}
