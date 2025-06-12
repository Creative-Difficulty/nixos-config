{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    grub_theme.enable = lib.mkEnableOption "Whether to enable a custom GRUB theme";
    terminal_emulator.choice = lib.mkOption {
      type = lib.types.string;
      default = "breeze";
      description = "Which terminal emulator to use";
    };
  };

  config = lib.mkIf config.grub_theme.enable {
    boot.loader.grub.theme = "${pkgs.libsForQt5.breeze-grub}/grub/themes/breeze";
  };
}
