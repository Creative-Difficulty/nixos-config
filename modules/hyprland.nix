{ lib, config, pkgs,  ... }: {
  options = {
    hyprland.enable = lib.mkEnableOption "Whether to enable the hyprland tiling window manager";
    hyprland.wlr_no_hardware_cursors = lib.mkEnableOption "Whether to set the WLR_NO_HARDWARE_CURSORS environment variable. This is useful in case your cursor becomes invisible";
  };

  config = lib.mkIf config.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = lib.mkIf config.hyprland.wlr_no_hardware_cursors "1";
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
