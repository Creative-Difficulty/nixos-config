# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  pkgs,
  config,
  lib,
  ...
}:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "pipe-operators"
  ];

  programs.nh = {
    enable = true;
    flake = "${config.vars.homeDirectory}/nixos-config";
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 5";
    };
  };

  imports = [
    ./hardware-configuration.nix

    ../../modules/default.nix

    ../../vars.nix
    ../../unfree.nix

    ../../lints.nix

    ./disko/1ssd_ext4_400gb.nix
  ];

  vars.mainUser = "alex";

  hyprland.enable = true;
  #  waybar.enable = true; # TODO make this an option in modules/waybar.nix

  # TODO set up breeze grub theme background image
  grub_theme.enable = true;

  steam.enable = true;

  brightness.enable = true;

  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings = {
      default_session = {
        user = "greeter";
        # Without --sessions, tuigreet lists each session twice (it's in two XDG_DATA_DIRS entries)
        command = "${lib.getExe' pkgs.tuigreet "tuigreet"} --remember --time --issue --cmd 'uwsm start hyprland-uwsm.desktop' --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"; # you may pass `--config` here
      };
    };
  };

  audio.enable = true;

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

  services.xserver.xkb.layout = "de";

  users.users.${config.vars.mainUser} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "wireshark" ]; # wheel: Enable ‘sudo’ for the user, wireshark: enable wireshark perms
    uid = config.vars.mainUserUid;
    hashedPassword = "$y$j9T$zyaR2zLGfatM/AxSzS3T51$pyVfeztgg6TcWmL5qIOiT.GYEkco5yFdTY/PBCsGbR2";
    # Keep the user manager (and with it user services like tmux) running without any login session,
    # e.g. after quitting Hyprland or when only connected via SSH
    linger = true;
    # packages = with pkgs; [];
  };

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark; # default is wireshark-cli (no GUI)
  };

  users.mutableUsers = false;

  environment.systemPackages = with pkgs; [
    # The Nano editor is installed by default
    fastfetch
    btop

    nixfmt
    nix-prefetch
    ckb-next
    kitty
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
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  # Flush logs to disk every second so the last moments before a hard power-off survive
  services.journald.settings.Journal.SyncIntervalSec = "1s";

  services.fail2ban = {
    enable = true;
    ignoreIP = [
      "127.0.0.1"
      "::1"
      # Ignore MBPVonAlex
      "192.168.0.111"
    ];
  };

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  system.stateVersion = "24.11";
}
