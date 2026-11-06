# TODOs

- [ ] Make yazi shell integration usable for fish/zsh/etc. or throw if not used with bash
- [ ] Fix versioning between nixpkgs, nixOS version and hm version
- [ ] Store a fixed wayvnc RSA key with agenix (`rsa_private_key_file`), so VNC viewers don't see a new server identity on every start
- [ ] Share the clipboard with the MacBook: either SSH one-liners (`pbpaste | ssh … wl-copy`, needs the Mac key in `dotfiles/.ssh/authorized_keys`) or KDE Connect (automatic, both ways, LAN-only firewall rule for 1714–1764)
