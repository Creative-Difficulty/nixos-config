{ pkgs, ... }:
{
  home.packages = [
    pkgs.direnv
    pkgs.nix-direnv
  ];

  home.file.".bashrc".text = ''
    eval "$(direnv hook bash)"
  '';
}
