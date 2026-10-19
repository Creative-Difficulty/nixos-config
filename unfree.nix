{ lib, config, ... }:
{
  options.unfree.allowed = lib.mkOption {
    description = "Names of unfree packages that are allowed to be installed. Modules append to this list.";
    default = [ ];
    type = lib.types.listOf lib.types.str;
  };

  # allowUnfreePredicate is a function, so a second definition silently overrides the first instead of merging.
  # Modules therefore add to the unfree.allowed list, and the predicate is defined only here.
  config.nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.unfree.allowed;
}
