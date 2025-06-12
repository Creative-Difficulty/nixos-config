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
