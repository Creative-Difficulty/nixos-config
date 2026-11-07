{
  lib,
  config,
  ...
}:
{
  options = {
    wayvnc_prereq.enable = lib.mkEnableOption "Whether to set up the system prerequisites of the Home Manager wayvnc module (PAM login, LAN firewall rule)";
  };

  config = lib.mkIf config.wayvnc_prereq.enable {
    # wayvnc has no NixOS module, so its enable_pam login needs this /etc/pam.d/wayvnc entry
    security.pam.services.wayvnc = { };

    # wayvnc only from the home LAN; allowedTCPPorts would also expose it over global IPv6
    networking.firewall.extraCommands = ''
      iptables -A nixos-fw -p tcp --dport 5900 -s 192.168.0.0/24 -j nixos-fw-accept
    '';
  };
}
