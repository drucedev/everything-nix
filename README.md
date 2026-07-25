# everything-nix

Druce's Nix flake for three machines: **Thor** (NixOS desktop, x86_64-linux),
**Ivaldi** (NixOS home server, x86_64-linux), **Odin** (macOS + nix-darwin,
x86_64-darwin).

## Install Thor / Ivaldi (NixOS)

From the NixOS minimal installer (flakes enabled):

```sh
git clone <repo-url> && cd everything-nix

# 1. Set the disk device in modules/nixos/<host>/disk.nix — replace the TODO
#    with the real whole-disk by-id path (find it: lsblk -o NAME,LINKS).

# 2. Partition + format + install in one step (WARNING: reformats the disk;
#    the device must match disk.nix):
sudo nix run github:nix-community/disko#disko-install -- --flake .#Thor --disk main /dev/nvme0n1
# or: --flake .#Ivaldi --disk main /dev/sda

# 3. Reboot, set the password:
sudo passwd druce

# 4. Secrets: generate the host age key, paste the printed PUBLIC key into
#    secrets.nix under the host's name:
sudo age-keygen -o /var/lib/agenix/age-key
```

Ivaldi only: after first boot, merge the `nixos-generate-config` hardware
output into `modules/nixos/ivaldi/hardware.nix` (TODO there), and add druce's
SSH `authorizedKeys` (openssh is enabled).

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
  repo; `stow` is installed on every host (`stow -t ~ <package>`).
- Manually disable Spotlight shortcuts that conflict with Raycast hotkeys: https://manual.raycast.com/hotkey
