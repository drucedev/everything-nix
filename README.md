# everything-nix

Druce's Nix flake for three machines: **Thor** (NixOS desktop, x86_64-linux),
**Ivaldi** (NixOS home server, x86_64-linux), **Odin** (macOS + nix-darwin,
x86_64-darwin).

## Install Thor (NixOS)

From the NixOS minimal installer (UEFI boot, flakes enabled):

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

No age key is needed for the initial Thor install. Configure agenix later when
secrets are introduced.

Ivaldi only: set its disk device in `modules/nixos/ivaldi/disk.nix` and use the
same two phases with `.#Ivaldi`; its disk layout differs from Thor. After the
first boot, merge the `nixos-generate-config` hardware output into
`modules/nixos/ivaldi/hardware.nix` (TODO there), and add druce's SSH
`authorizedKeys` (openssh is enabled).

## Install / update Odin (macOS)

First time: install Nix with flakes — the
[Determinate installer](https://github.com/DeterminateSystems/nix-installer)
in plain-Nix mode works (nix-darwin manages the Nix config afterwards) — and
[nix-darwin](https://github.com/nix-darwin/nix-darwin).

```sh
darwin-rebuild switch --flake .#Odin

# Secrets: generate the age key, pubkey -> secrets.nix under `odin`:
sudo age-keygen -o /etc/age/age-key
```

## Rebuild

```sh
sudo nixos-rebuild switch --flake .#Thor      # on Thor
sudo nixos-rebuild switch --flake .#Ivaldi    # on Ivaldi
darwin-rebuild switch --flake .#Odin          # on Odin
```

## Update

```sh
nix flake update
```

A GitHub Action also bumps `flake.lock` daily (within the pinned branches).
Do NOT repoint the `nixpkgs` / `darwin` inputs past their 26.05 branches —
26.05 is the last release supporting Odin's x86_64-darwin. (`nixpkgs-stable`
and `nixpkgs-unstable` may advance.)

## Dev shells

```sh
nix develop            # tools for editing this flake (nixd, nixfmt, git)
nix develop .#kotlin
nix develop .#zig
```

## Formatting & checks

```sh
nix fmt
nix flake check --no-build
```

## Secrets (agenix)

Host public keys live in `secrets.nix`. Add a secret:

```sh
nix run github:ryantm/agenix -- -e mysecret.age
# then reference it in a host module:
#   age.secrets.mysecret.file = ../../mysecret.age;
```

## Notes

- Dotfiles are NOT managed here — separate [GNU stow](https://www.gnu.org/software/stow/)
  repo; `stow` is installed on Odin and Thor (`stow -t ~ <package>`). Ivaldi's
  user package set is deferred until its server role is designed.
- Manually disable Spotlight shortcuts that conflict with Raycast hotkeys: https://manual.raycast.com/hotkey
