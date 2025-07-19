{ lib, config, ... }:
{
  options.vars = {
    mainUser = lib.mkOption {
      description = "Name of the main user of the system";
      default = "alex";
    };

    homeDirectory = lib.mkOption {
      description = "Home directory of the main user of the system";
      default = "/home/${config.vars.mainUser}";
      type = lib.types.path;
    };

    keysDirectory = lib.mkOption {
      description = "SSH and other keys directory of the main user of the system";
      default = "${config.vars.homeDirectory}/keys";
      type = lib.types.path;
    };

    # TODO: Automate detection and change if wrong
    mainUserXdgRuntimeDir = lib.mkOption {
      description = "XDG_RUNTIME_DIR directory of the main user of the system";
      default = "/run/user/12306";
    };

    # hostname = lib.mkOption {
    #   description = "The hostname for the system";
    #   default = "default-hostname";
    # };

    # timeZone = lib.mkOption {
    #   description = "The time zone for the system";
    #   default = "UTC";
    # };
  };
}
