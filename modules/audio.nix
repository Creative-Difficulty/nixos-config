{ lib, config, ... }: {
  imports = [
    ../vars.nix
  ];

  options = {
    audio.enable = lib.mkEnableOption "Whether to enable Audio";
    audio.server = lib.mkOption {
      type = lib.types.enum [ "pipewire" "pulseaudio" ];
      default = "pipewire";
      description = "Which audio server to use";
    };
  };

  config = lib.mkIf config.audio.enable {
    users.users.${config.vars.mainUser}.extraGroups = [ "audio" ];

    services.pipewire = lib.mkIf (config.audio.server == "pipewire") {
      enable = true;
      audio.enable = true;
    };

    hardware.pulseaudio = lib.mkIf (config.audio.server == "pulseaudio") {
      enable = true;
    };
  };
}
