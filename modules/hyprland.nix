{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    hyprland.enable = lib.mkEnableOption "Whether to enable the hyprland tiling window manager";
  };

  config = lib.mkIf config.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
