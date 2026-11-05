{
  lib,
  config,
  ...
}:
{
  options = {
    wayvnc.enable = lib.mkEnableOption "Whether to allow LAN logins to the wayvnc VNC server";
  };

  config = lib.mkIf config.wayvnc.enable {
    # wayvnc has no NixOS module, so its enable_pam login needs this /etc/pam.d/wayvnc entry
    security.pam.services.wayvnc = { };

    # wayvnc only from the home LAN; allowedTCPPorts would also expose it over global IPv6
    networking.firewall.extraCommands = ''
      iptables -A nixos-fw -p tcp --dport 5900 -s 192.168.0.0/24 -j nixos-fw-accept
    '';
  };
}
