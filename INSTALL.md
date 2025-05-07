# How to install this configuration flake using nixos-anywhere

## 1. On target (in installer)

1. Make sure you're installing NixOS on its own drive, as disko will first nuke the drive it's used on
2. (Run `sudo su` to become superuser) Maybe not bc we use the `nixos` user instead for installing anyways
3. Run `passwd` to set the user (and ssh password)
4. Run `ip addr` to get IP address
5. Get the drive paths (`sudo fdisk -l`) and adjust them in the disko configuration if necessary
    - After installing, modify the configuration to use the path or uuid or model or smth instead of z.B. `/dev/nvme0n1`

## 2. On host

1. Make Sure Nix is installed and add `experimental-features = nix-command flakes` to the `nix.conf`
2. Run:

    ```bash
    SSHPASS='sshpassword' nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config ./hosts/nixosbtw/hardware-configuration.nix --flake '.#nixosbtw' --env-password 'sshpassword' --build-on remote --target-host nixos@192.168.0.100
    ```

## 3. After install

(NOTE: YOU HAVE TO BOOT THE INSTALLER IN UEFI MODE)?

1. Copy configuration over to the target machine: `git clone https://github.com/Creative-Difficulty/nixos-config.git`
2. Run `sudo nixos-rebuild switch --flake .#nixosbtw` to make sure the config from the Git repo gets applied over the one used by nixos-anywhere.
3. Install home-manager standalone:

    ```bash
    nix-shell '<home-manager>' -A install
    ```

4. Build & activate the home-manager config: `home-manager switch --flake .`

## 4. Tidbits/cheatsheet

- To update the flake's inputs: `nix flake update` (or `nix flake lock`?)
- yazi Keybindings: <https://yazi-rs.github.io/docs/quick-start/#keybindings>
- To install home-manager standalone with flakes (like this configuration) follow this official guide: <https://home-manager.dev/manual/24.11/index.xhtml#sec-flakes-standalone>

## 5. Notes pertaining to the current state of this config

- TODO: configure window swallowing hyprland: <https://www.reddit.com/r/hyprland/comments/xsk2ty/comment/jarfecv/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button>
- TODO: Test [persistent disk names](https://wiki.archlinux.org/title/Persistent_block_device_naming#:~:text=the%20mkswap%20utility.-,by%2Did%20and%20by%2Dpath,-by%2Did) by [reformatting using disko](https://github.com/nix-community/disko/blob/master/docs/quickstart.md#step-6-run-disko-to-partition-format-and-mount-your-disks), try to make it non-destructive using only the `mount` mode argument?.
- TODO: Declare git ssh private and public keys (sops-nix?) using home-manager. Load the key onto a USB as a primary medium?
