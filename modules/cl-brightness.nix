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

    hardware.i2c.enable = true;
    users.users.${config.vars.mainUser}.extraGroups = [ "i2c" ];

    # nouveau's DP AUX bus isn't auto-probed, so attach ddcci to the bus named after the connector.
    # The bus only appears once nouveau has loaded, so a udev rule starts the attach service when it does
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="i2c", ATTR{name}=="${config.brightness.connector}", TAG+="systemd", ENV{SYSTEMD_WANTS}+="ddcci-attach@%k.service"
    '';

    # Right after the bus appears the monitor often doesn't answer yet (probe fails with -19), so retry
    systemd.services."ddcci-attach@" = {
      description = "Attach ddcci driver to i2c bus %i";
      serviceConfig.Type = "oneshot";
      scriptArgs = "%i";
      script = ''
        bus=/sys/bus/i2c/devices/$1
        dev=$bus/''${1#i2c-}-0037
        for attempt in $(seq 1 10); do
          [ -e "$dev" ] && echo 0x37 > "$bus/delete_device"
          echo ddcci 0x37 > "$bus/new_device"
          # The driver link only exists if the monitor answered the probe
          if [ -e "$dev/driver" ]; then
            echo "ddcci attached on attempt $attempt"
            exit 0
          fi
          sleep 3
        done
        echo "Monitor didn't answer DDC/CI after $attempt attempts"
        exit 1
      '';
    };

    environment.systemPackages = with pkgs; [
      brightnessctl
      ddcutil
    ];
  };
}
