{ lib, config, pkgs, ... }: {
  options = {
    terminal_emulator.enable = lib.mkEnableOption "Whether to enable a terminal emulator";
    terminal_emulator.choice = lib.mkOption {
      type = lib.types.enum [ "kitty" "alacritty" ];
      default = "kitty";
      description = "Which terminal emulator to use";
    };
    };
    config = lib.mkIf config.terminal_emulator.enable {
      environment.systemPackages = [ pkgs.kitty ]; # TODO!!!
    };
 }
