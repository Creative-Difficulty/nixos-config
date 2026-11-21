{
  lib,
  config,
  ...
}:
{
  options = {
    sunshine.enable = lib.mkEnableOption "Whether to enable the on-demand Sunshine game stream host for Moonlight";
  };

  config = lib.mkIf config.sunshine.enable {
    services.sunshine = {
      enable = true;
      autoStart = false;
      capSysAdmin = true;
    };

    # Not openFirewall, which opens every interface and the web UI (47990); pairing stays local
    networking.firewall.interfaces.${config.vars.lanInterface} = {
      allowedTCPPorts = [
        47984
        47989
        48010
      ];
      allowedUDPPorts = [
        47998
        47999
        48000
        48002
        48010
      ];
    };
  };
}
