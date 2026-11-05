{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    wayvnc.enable = lib.mkEnableOption "Whether to install the on-demand wayvnc VNC server";
  };

  config = lib.mkIf config.wayvnc.enable {
    home.packages = [ pkgs.wayvnc ];

    # No WantedBy: started on demand, and Requisite keeps it from starting outside Hyprland
    systemd.user.services.wayvnc = {
      Unit = {
        Description = "wayvnc VNC server";
        Requisite = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service.ExecStart = "${lib.getExe pkgs.wayvnc} --render-cursor";
    };
  };
}
