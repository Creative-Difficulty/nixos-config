{ lib, config, ... }: {
  options.vars = {
    mainUser = lib.mkOption {
      description = "Name of the main user of the system";
      default = "alex";
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

# 1. Run `passwd`
# 1. Run `ip addr` to get IP address

# TODO copy configuration over to target machine
