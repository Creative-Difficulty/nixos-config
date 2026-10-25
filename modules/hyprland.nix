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

    # Its binary is in libexec; hyprland.lua starts it since graphical-session.target never runs
    environment.systemPackages = [
      pkgs.hyprpolkitagent
      pkgs.kdePackages.dolphin
    ];
    environment.pathsToLink = [ "/libexec" ];
  };
}
