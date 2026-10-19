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
    # This is a udev rule instead of a boot service, because the bus only appears once nouveau has loaded
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="i2c", ATTR{name}=="${config.brightness.connector}", RUN+="${pkgs.bash}/bin/sh -c 'echo ddcci 0x37 > /sys%p/new_device'"
    '';

    environment.systemPackages = with pkgs; [
      brightnessctl
      ddcutil
    ];
  };
}
