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

---

## 3. After install

(NOTE: YOU HAVE TO BOOT THE INSTALLER IN UEFI MODE)?

1. Copy configuration over to target machine: `git clone https://github.com/Creative-Difficulty/nixos-config.git`
2. Run `sudo nixos-rebuild switch --flake .#nixosbtw`
3. Install home-manager standalone:

    ```bash
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    nix-shell '<home-manager>' -A install
    ```

4. Build & use the home-manager config: `home-manager switch --flake .`

TODO: Use git ssh with public/private keys.
TODO: configurae windwo swallowing
TODO: fix disk names to make them oersistent in disko
