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

    # graphical-session.target refuses manual starts; hyprland.lua starts this instead
    systemd.user.targets.hyprland-session = {
      description = "Hyprland session";
      bindsTo = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
    };

    systemd.packages = [ pkgs.hyprpolkitagent ];
    systemd.user.services.hyprpolkitagent.wantedBy = [ "graphical-session.target" ];

    environment.systemPackages = [ pkgs.kdePackages.dolphin ];
  };
}
