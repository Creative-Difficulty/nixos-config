{
  lib,
  config,
  ...
}:
{
  options = {
    kdeconnect_prereq = {
      enable = lib.mkEnableOption "Whether to set up the system prerequisites of the Home Manager KDE Connect service (LAN firewall ports)";

      lanInterface = lib.mkOption {
        description = "Network interface of the home LAN, the only one KDE Connect is reachable on";
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf config.kdeconnect_prereq.enable {
    networking.firewall.interfaces.${config.kdeconnect_prereq.lanInterface} =
      let
        range = [
          {
            from = 1714;
            to = 1764;
          }
        ];
      in
      {
        allowedTCPPortRanges = range;
        allowedUDPPortRanges = range;
      };
  };
}
