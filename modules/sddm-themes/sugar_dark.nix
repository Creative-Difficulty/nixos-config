{
  stdenv,
  fetchFromGitHub,
  lib,
  pkgs,
  ...
}:
let
  version = "1.2";
in
stdenv.mkDerivation {
  pname = "sddm-sugar-dark-theme";
  inherit version;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -aR $src $out/share/sddm/themes/sugar-dark
  '';
  src = fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-sugar-dark";
    rev = "v${version}";
    sha256 = "0gx0am7vq1ywaw2rm1p015x90b75ccqxnb1sz3wy8yjl27v82yhb";
  };
}
