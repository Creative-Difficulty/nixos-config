{
  lib,
  config,
  ...
}:
{
  options = {
    hyprlock_prereq.enable = lib.mkEnableOption "Whether to set up the system prerequisites of the Home Manager hyprlock package (PAM login)";
  };

  config = lib.mkIf config.hyprlock_prereq.enable {
    # Without /etc/pam.d/hyprlock, PAM falls back to "other", which rejects every password
    security.pam.services.hyprlock = { };
  };
}
