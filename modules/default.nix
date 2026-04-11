{ lib, ... }:
let
  fileUtils = import ../utils.nix { inherit lib; };
in
{
  imports = fileUtils.nixFilesIn ./.;
}
