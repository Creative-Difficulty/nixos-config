{
  config,
  pkgs,
  ragenix,
  ...
}:
{
  imports = [
    ../vars.nix
    ./programs/yazi/yazi.nix
  ];

  yazi = {
    enable = true;
    bleedingEdge = true;
    enableCommandAlias = true;
    commandAlias = "y";
    enableShellWrapper = true;
  };

  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "${config.vars.mainUser}";
  home.homeDirectory = "${config.vars.homeDirectory}";

  age = {
    identityPaths = [ "${config.vars.masterAgeDecryptionKeyPath}" ];

    # Changed to this, because under home-manager you either have to manually expand the XDG_RUNTIME_DIR
    # or set it to /run/user/... or set it to something in the home directory (basically somewhere where the user has write access)
    # Tracking issue: https://github.com/ryantm/agenix/issues/300
    secretsDir = "${config.vars.homeDirectory}/agenix";

    # Always 'git add .' before rebuilding when adding a new secret as it won't be copied to the nix store (and won't be found by agenix) otherwise
    secrets.alex_github_ssh_key = {
      file = ./secrets/alex_github_1.age;
      # TODO: Does this make any difference?
      #      owner = "alex";
      #      mode = "770";
    };
  };

  # TODO: Fix not being able to use home.homeDirectory here for some reason
  home.file = {
    ".ssh/config".source = pkgs.replaceVars ../dotfiles/.ssh/config {

      #github_key = "/home/alex/keys/alex_github_1";
      github_key = "${config.age.secrets.alex_github_ssh_key.path}";
    };
    ".gitconfig".source = ../dotfiles/.gitconfig;
    # Note: Hyprland has to be enabled from the system module, home-manager just manages the configuration file
    ".config/hypr/hyprland.conf".source = ../dotfiles/hyprland.conf;
    ".config/kitty/kitty.conf".source = ../dotfiles/kitty.conf;
    #    "${config.vars.homeDirectory}/.config/xyz" = {
    #      text = ''${config.age.secrets.alex_github_ssh_key.path}'';
    #    };
    # "agenixapth".text = ''${builtins.getEnv "XDG_RUNTIME_DIR"}/agenix'';
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    librewolf
    tree
    lazygit

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/alex/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
