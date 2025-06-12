{ pkgs, wrapperName }:
let
  bashZshShellWrapper = builtins.readFile (
    pkgs.replaceVars ./bashZshShellWrapper { shellwrappername = "${wrapperName}"; }
  );
in
bashZshShellWrapper
