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
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    nix-shell '<home-manager>' -A install
    ```

4. Build & use the home-manager config: `home-manager switch --flake .`

---

## 4. Tidbits/cheatsheet

- To update the flake's inputs in the lockfile: `nix flake update`
- yazi Keybindings: <https://yazi-rs.github.io/docs/quick-start/#keybindings>
- REPL: `nix repl`
- Find a specific version of a package: <https://www.nixhub.io/>

## 5. Guides

### Installing `ventoy` on a USB and copying ISOs to it using NixOS

> [!NOTE]
> `<usbpath>` stands for the filesystem-path to the USB drive. For example: `/dev/sda`. Get the correct path by running `lsblk` and identifying the correct storage medium.

1. For some reason, installation via the web-UI as described [in this blog post](https://haseebmajid.dev/posts/2023-09-29-setup-ventoy-on-nixos/]) doesn't work. Instead, the CLI installs ventoy successfully with the following commands as of NixOS 25.05:
This doesn't clutter your system with ventoy-related files, as it only instantiates a nix-shell with the program available. Note that some users have reported only the GPT table option being able to boot into ventoy correctly (I have expericened this myself) on a UEFI system. It might be worth considering using the GPT table format as per the [linux cli documentation](https://www.ventoy.net/en/doc_start.html#doc_linux_cli)
    > [!WARNING] This will unrecoverably delete all data on the specified drive. Double check the path before executing this command.

    ```bash
    nix-shell -p ventoy-full
    sudo ventoy -I /dev/<usbpath>
    ```

2. Mount the USB stick to copy the ISOs there
    > [!WARNING]
    >In this guide `<usbpath>1` points to the first partition on the USB drive. Verify that it does so on your storage medium of choice and adjust the path if needed. Newer NVME SSDs for example use `nvmeXnXp1` (where `X` is a number) to point to the first partition.[^1]
    > Mount only the first partition, as it is the location where the ISOs are stored (as of ventoy v1.1.00).

    1. Run

       ```bash
        sudo mkdir -p /mnt/ventoy-usb-stick/
        sudo mount /dev/<usbpath>1 /mnt/ventoy-usb-stick
        ```

        to create the `/mnt` directory and mount the USB stick there.

    2. Copy the ISOs to the USB:

        ```bash
        sudo cp /path/to/iso/debian-xyz.iso /mnt/ventoy-usb-stick/
        ```

    3. Eject the USB:

        ```bash
        sudo eject /dev/<usbpath>
        ```

    4. If no errors were displayed, you can now safely remove the USB drive and use it to boot your ISOs!

## 6. TODOs pertaining to the current state of this config

- [ ] TODO: Declare git ssh private and public keys (sops-nix?) using home-manager. Load the key onto a USB as a primary medium?
- [ ] TODO: Declare Hyprland keyboard layout using home-manager
- [ ] TODO: fix confusion with flake- and standalone home-manager
- [ ] TODO: configure window swallowing hyprland: <https://www.reddit.com/r/hyprland/comments/xsk2ty/comment/jarfecv/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button>
- [ ] TODO: Test [persistent disk names](https://wiki.archlinux.org/title/Persistent_block_device_naming#:~:text=the%20mkswap%20utility.-,by%2Did%20and%20by%2Dpath,-by%2Did) by [reformatting using disko](https://github.com/nix-community/disko/blob/master/docs/quickstart.md#step-6-run-disko-to-partition-format-and-mount-your-disks), try to make it non-destructive using only the `mount` mode argument?.

## 7. Future endeavors with this config

- [ ] Firefox -> Librewolf
- [ ] Declare Firefox and vscodium preferences and extensions
- [ ] Use home-manager also on mac
- [ ] Comfy nix tree thingy (vimjoyer video)

- [ ] Extract tidbits into blog/tidbits section in website and but them in extra repo with astro markdown thing generation
- [ ] Use footnotes as citations and sources for everything
- [ ] Blog post/tidbit/tutroial on drive naming
  - <https://wiki.archlinux.org/title/Persistent_block_device_naming#:~:text=the%20mkswap%20utility.-,by%2Did%20and%20by%2Dpath,-by%2Did>) by [reformatting using disko](<https://github.com/nix-community/disko/blob/master/docs/quickstart.md#step-6-run-disko-to-partition-format-and-mount-your-disks>
  - <https://askubuntu.com/questions/56929/what-is-the-linux-drive-naming-scheme>
  - <https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/managing_storage_devices/persistent-naming-attributes_managing-storage-devices#persistent-naming-attributes_managing-storage-devices>

[^1]:<https://askubuntu.com/questions/56929/what-is-the-linux-drive-naming-scheme>
