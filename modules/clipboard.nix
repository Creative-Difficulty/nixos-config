{ lib, config, pkgs, ... }: {
  options = {
    clipboard.enable = lib.mkEnableOption "Whether to enable the clipboard";
  };

  config = lib.mkIf config.clipboard.enable {  
    environment.systemPackages = with pkgs; [
      cliphist
    ];
  };
}
