{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    podman.enable = lib.mkEnableOption "Whether to enable rootless Podman with a docker-compatible CLI";
  };

  config = lib.mkIf config.podman.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      # Lets compose services resolve each other by name
      defaultNetwork.settings.dns_enabled = true;
    };

    environment.systemPackages = with pkgs; [
      podman-compose
    ];
  };
}
