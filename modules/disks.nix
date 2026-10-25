{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    disks.enable = lib.mkEnableOption "Whether to enable GUI disk management tools";
  };

  config = lib.mkIf config.disks.enable {
    services.udisks2.enable = true;

    programs.partition-manager.enable = true;

    environment.systemPackages = with pkgs; [
      kdePackages.filelight
    ];
  };
}
