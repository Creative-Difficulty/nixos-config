{ config, pkgs, ... }: {
  boot.extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];
  boot.kernelModules = [ "ddcci_backlight" ];

  # nouveau's DP AUX bus isn't auto-probed, so attach ddcci to the bus named DP-1
  systemd.services.ddcci-attach = {
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" ];
    serviceConfig.Type = "oneshot";
    script = ''
      for b in /sys/bus/i2c/devices/i2c-*; do
        [ "$(cat "$b/name")" = "DP-1" ] && echo ddcci 0x37 > "$b/new_device"
      done
    '';
  };

  environment.systemPackages = [ pkgs.brightnessctl ];
}

