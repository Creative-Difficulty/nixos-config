{ pkgs, lib, ... }: {
  config = {
    environment.systemPackages = with pkgs; [
      waybar
      (waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ]; }))
    ];

#    audio.enable = lib.mkOverride 0 true; # TODO!!!!

  #  hardware = {
      # TODO lib.mkOverride or smth like that
   #   pulseaudio = {
    #    enable = true;
     #   support32Bit = true;
     # };
   # };
  };
}
