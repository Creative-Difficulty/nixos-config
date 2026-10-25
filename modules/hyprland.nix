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

    # Upstream fc77bd5 (exit segfault, hyprwm/aquamarine#383); guard drops it once nixpkgs ships > 0.15.1
    nixpkgs.overlays = [
      (final: prev: {
        aquamarine = prev.aquamarine.overrideAttrs (old: {
          patches =
            (old.patches or [ ])
            ++ lib.optional (lib.versionOlder old.version "0.15.2") ./patches/aquamarine-fix-null-connector-flush.patch;
        });
      })
    ];

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
