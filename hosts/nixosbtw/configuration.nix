# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, config, ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "pipe-operators"
  ];

  imports = [
    ./hardware-configuration.nix

    ../../modules/default.nix

    ../../vars.nix

    ../../lints.nix

    ./disko/1ssd_ext4_400gb_kingston.nix
  ];

  vars.mainUser = "alex";

  hyprland.wlr_no_hardware_cursors = true;
  hyprland.enable = true;
  #  waybar.enable = true; # TODO make this an option in modules/waybar.nix

  terminal_emulator.enable = true; # "kitty" by default

  # TODO set up breeze grub theme background image
  grub_theme.enable = true;

  audio.enable = true;
  sddm.enable = true;

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
      # Wait indefinitely to choose a boot option
      extraConfig = ''
        set timeout=-1
      '';
    };
  };

  networking.hostName = "nixosbtw";

  time.timeZone = "Europe/Vienna";
  time.hardwareClockInLocalTime = true;

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  users.users.${config.vars.mainUser} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    uid = config.vars.mainUserUid;
    hashedPassword = "$y$j9T$zyaR2zLGfatM/AxSzS3T51$pyVfeztgg6TcWmL5qIOiT.GYEkco5yFdTY/PBCsGbR2";
    # packages = with pkgs; [];
  };

  users.mutableUsers = false;

  environment.systemPackages = with pkgs; [
    # The Nano editor is installed by default!
    fastfetch
    btop
    nixfmt-rfc-style
    nix-prefetch
  ];

  programs.git = {
    enable = true;
    config = {
      init = {
        defaultBranch = "main";
      };
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      AllowUsers = [ "${config.vars.mainUser}" ];
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
    };
    # ports = [ 22 ];
  };

  services.fail2ban = {
    enable = true;
    # Ignore its own IP and MBPVonAlexander locally
    ignoreIP = [
      "127.0.0.1"
      "::1"
      "192.168.0.111"
    ];
  };

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  #   users.users.root.openssh.authorizedKeys.keys = [
  #     "CHANGE"
  #   ];

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  system.stateVersion = "24.11";
}
