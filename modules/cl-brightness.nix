{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    brightness.enable = lib.mkEnableOption "Whether to enable external monitor brightness control via DDC/CI";
    brightness.connector = lib.mkOption {
      type = lib.types.str;
      default = "DP-1";
      description = "Name of the i2c bus (the monitor's connector) to attach the ddcci driver to";
    };
  };

  config = lib.mkIf config.brightness.enable {
    boot.extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];
    boot.kernelModules = [ "ddcci_backlight" ];

    # nouveau's DP AUX bus isn't auto-probed, so attach ddcci to the bus named after the connector
    systemd.services.ddcci-attach = {
      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-modules-load.service" ];
      serviceConfig.Type = "oneshot";
      script = ''
        for b in /sys/bus/i2c/devices/i2c-*; do
          [ "$(cat "$b/name")" = "${config.brightness.connector}" ] && echo ddcci 0x37 > "$b/new_device"
        done
      '';
    };

    environment.systemPackages = [ pkgs.brightnessctl ];
  };
}
