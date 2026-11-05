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

    # Home LAN only, since openFirewall would also expose global IPv6; the web UI (47990) stays local for pairing
    networking.firewall.extraCommands = ''
      iptables -A nixos-fw -p tcp -m multiport --dports 47984,47989,48010 -s 192.168.0.0/24 -j nixos-fw-accept
      iptables -A nixos-fw -p udp -m multiport --dports 47998,47999,48000,48002,48010 -s 192.168.0.0/24 -j nixos-fw-accept
    '';
  };
}
