# Install Thor

NixOS desktop, x86_64-linux. From the NixOS minimal installer (UEFI boot, flakes
enabled):

```sh
# Keep the checkout outside /mnt; disko mounts the target system there.
git clone <repo-url> /tmp/everything-nix
cd /tmp/everything-nix

# Confirm this is the whole target disk, never a partition:
lsblk -o NAME,PATH,SIZE,TYPE,MODEL,SERIAL,FSTYPE,MOUNTPOINTS
readlink -f /dev/disk/by-id/nvme-KINGSTON_SKC3000D2048G_50026B768629E5B7

# WARNING: erases the disk configured in modules/nixos/thor/disk.nix.
sudo nix run github:nix-community/disko#disko -- \
  --mode destroy,format,mount \
  --flake .#Thor

# nixos-install prompts for the root password.
sudo nixos-install --flake .#Thor --root /mnt
sudo nixos-enter --root /mnt -c 'passwd druce'
cd /
sudo umount -R /mnt
sudo reboot
```

After first boot, clone a persistent checkout to rebuild from, then stow
dotfiles from their separate repository (`stow -t ~ <package>`):

```sh
git clone <repo-url> "$HOME/everything-nix"
```

## Rebuild and update

```sh
sudo nixos-rebuild switch --flake .#Thor
nix flake update   # a GitHub Action also does this daily
```

## T3 Code mobile

Thor pins T3 Code to TCP `3773` (`T3CODE_PORT`) and opens it on the Wi-Fi
interface `wlo1`. After rebuilding, quit T3 Code, log out and back in, relaunch
it, then pair from the phone on the same network.

The port is open on every Wi-Fi network Thor joins, so keep T3's
authentication on. No router forwarding is needed. If another process holds
`3773`, T3 fails to bind instead of picking another port.

## Quickshell

Thor installs Quickshell but does not autostart it. Its config lives in the
dotfiles repo under `linux/.config/quickshell/druce/`; once stowed with a
`shell.qml`, run `qs -c druce`.

## Secrets

No age key is needed to install. When adding secrets, generate the key, paste
the public key under `thor` in `secrets.nix`, then edit a secret:

```sh
sudo age-keygen -o /var/lib/agenix/age-key
sudo age-keygen -y /var/lib/agenix/age-key
nix run github:ryantm/agenix -- -e mysecret.age
```

Reference it from a host module:
`age.secrets.mysecret.file = ../../mysecret.age;`
