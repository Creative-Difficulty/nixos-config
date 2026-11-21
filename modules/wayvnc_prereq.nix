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

    networking.firewall.interfaces.${config.vars.lanInterface}.allowedTCPPorts = [ 5900 ];
  };
}
