let
  wrapperName = "y";
  bashZshShellWrapper = pkgs.replaceVars ./bashZshShellWrapper { shellwrappername = "${wrapperName}"; };
in 
  bashZshShellWrapper
