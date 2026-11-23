# TODOs

- [ ] Make yazi shell integration usable for fish/zsh/etc. or throw if not used with bash
- [ ] Fix versioning between nixpkgs, nixOS version and hm version
- [ ] Share the clipboard with the MacBook: either SSH one-liners (`pbpaste | ssh … wl-copy`, needs the Mac key in `dotfiles/.ssh/authorized_keys`) or KDE Connect (automatic, both ways, LAN-only firewall rule for 1714–1764)
- [ ] Hyprland overview of workspaces 1–9 on Super+Tab: no native feature in 0.56; try the `hyprtasking` plugin (check its Lua-config dispatcher name first)
- [ ] Keep Zed's extension list in the repo automatically: a systemd user path unit watching `~/.local/share/zed/extensions/installed/` that rewrites the `auto_install_extensions` block in `dotfiles/.config/zed/settings.json` (only that block, the file is JSONC; skip symlinked dev extensions)
- [ ] After the next reboot (NIC renamed to `lan`), remove the transitional `networking.firewall.interfaces.enp3s0` rules and the `options` argument in `hosts/nixosbtw/configuration.nix`
