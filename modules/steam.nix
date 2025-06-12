{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    steam.enable = lib.mkEnableOption "Whether to enable Steam";
  };

  config = lib.mkIf config.steam.enable {
    programs.steam = {
      enable = true;
      # remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      # dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      # localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
        "steam-unwrapped"
        "steam-run"
      ];

    environment.systemPackages = with pkgs; [
      steam-run
    ];
  };
}
