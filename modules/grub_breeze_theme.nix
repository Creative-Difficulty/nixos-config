{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    grub_theme.enable = lib.mkEnableOption "Whether to enable the breeze GRUB theme";
  };

  config = lib.mkIf config.grub_theme.enable {
    boot.loader.grub = {
      theme = "${pkgs.libsForQt5.breeze-grub}/grub/themes/breeze";
      splashImage = null;
    };
  };
}
