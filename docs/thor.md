# Install Thor

NixOS desktop, x86_64-linux. From the NixOS minimal installer (UEFI boot, flakes
enabled):

```sh
# Keep the checkout outside /mnt; disko will use /mnt for the target system.
git clone <repo-url> /tmp/everything-nix
cd /tmp/everything-nix

# Confirm this is the whole target disk, never a partition:
lsblk -o NAME,PATH,SIZE,TYPE,MODEL,SERIAL,FSTYPE,MOUNTPOINTS
readlink -f /dev/disk/by-id/nvme-KINGSTON_SKC3000D2048G_50026B768629E5B7

# 1. Destroy, partition, format, and mount Thor at /mnt.
#    WARNING: this erases the disk configured in modules/nixos/thor/disk.nix.
sudo nix run github:nix-community/disko#disko -- \
  --mode destroy,format,mount \
  --flake .#Thor

# 2. Install NixOS, set both passwords while /mnt is mounted, then reboot.
#    nixos-install prompts for the root password.
sudo nixos-install --flake .#Thor --root /mnt
sudo nixos-enter --root /mnt -c 'passwd druce'
cd /
sudo umount -R /mnt
sudo reboot
```

The live-installer checkout is temporary. After first boot, clone a persistent
checkout for future rebuilds:

```sh
git clone <repo-url> "$HOME/everything-nix"
cd "$HOME/everything-nix"
```

No age key is needed for the initial install. Configure agenix later when
secrets are introduced.

Dotfiles are not in this repo. Stow them from the separate repository:
`stow -t ~ <package>`.

## Rebuild

```sh
sudo nixos-rebuild switch --flake .#Thor
```

## T3 Code mobile

Thor pins T3 Code to TCP port `3773` using `T3CODE_PORT` and allows incoming
connections on its Wi-Fi interface (`wlo1`). After rebuilding, fully quit T3
Code, log out and back in to pick up the session variable, then relaunch it.
Use T3's pairing flow from the phone on the same network.

The firewall exception applies on every Wi-Fi network Thor joins, not just to
your phone; keep T3's authentication enabled. No router port forwarding is
needed. If another process occupies port `3773`, T3 will fail to bind rather
than select a different port.

## Quickshell

Thor includes the Quickshell runtime with Qt Quick, Wayland, and SVG support.
Apply it with the rebuild command above. Shell code belongs in the separate
dotfiles repo, under `linux/.config/quickshell/druce/`; once stowed and
containing `shell.qml`, run it manually with `qs -c druce`. No Quickshell
autostart is configured; Waybar remains enabled.

## Update

```sh
nix flake update
```

A GitHub Action also bumps `flake.lock` daily, within the pinned branches.
Do not repoint the `nixpkgs` or `darwin` inputs past their 26.05 branches.
26.05 is the last release that supports Odin's x86_64-darwin. `nixpkgs-stable`
and `nixpkgs-unstable` may advance.

## Secrets

Host public keys live in `secrets.nix`. Generate Thor's age key when secrets
are introduced, paste the public key under `thor`, then edit a secret:

```sh
sudo age-keygen -o /var/lib/agenix/age-key
sudo age-keygen -y /var/lib/agenix/age-key
nix run github:ryantm/agenix -- -e mysecret.age
```

Reference it from a host module:

```nix
age.secrets.mysecret.file = ../../mysecret.age;
```
