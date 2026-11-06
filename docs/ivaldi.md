# Install Ivaldi

Headless NixOS home server, x86_64-linux: UEFI, GPT with an ESP, systemd-boot.
It carries the shared CLI baseline plus `tmux`, `age`, Pi, Claude Code, Open
Code Review (`ocr`), and the T3 Code server (`t3`) with its provider CLIs.

## Before the installer

1. Set `device` in `modules/nixos/ivaldi/disk.nix` to the whole target disk,
   never a partition. From the installer:

   ```sh
   lsblk -o NAME,PATH,SIZE,TYPE,MODEL,SERIAL,FSTYPE,MOUNTPOINTS
   ls -l /dev/disk/by-id
   ```

2. SSH is key-only, with Thor's key already in `modules/nixos/ivaldi.nix`. Add
   any other public key to `users.users.druce.openssh.authorizedKeys.keys`
   there. The console password still works, including for `sudo`.

3. Install from a checkout with those edits: push them first, or edit the live
   checkout before running disko.

## Install

From the NixOS minimal installer (UEFI boot, flakes enabled), on wired DHCP or
Wi-Fi via `nmtui`:

```sh
# Keep the checkout outside /mnt; disko mounts the target system there.
git clone <repo-url> /tmp/everything-nix
cd /tmp/everything-nix
readlink -f /dev/disk/by-id/<the-id-in-disk.nix>

# WARNING: erases the disk configured in modules/nixos/ivaldi/disk.nix
# (512M ESP, 4G swap, ext4 root).
sudo nix run github:nix-community/disko#disko -- \
  --mode destroy,format,mount \
  --flake .#Ivaldi

# nixos-install prompts for the root password (console only; root SSH is off).
sudo nixos-install --flake .#Ivaldi --root /mnt
sudo nixos-enter --root /mnt -c 'passwd druce'
cd /
sudo umount -R /mnt
sudo reboot
```

## First boot

Find the address on the console (`ip -4 addr`), then `ssh druce@<ivaldi-ip>`
from Thor. Clone a persistent checkout and merge the real hardware config:

```sh
git clone <repo-url> "$HOME/everything-nix"
cd "$HOME/everything-nix"
# Copy everything except filesystem and swap entries (disko owns those)
# into modules/nixos/ivaldi/hardware.nix:
sudo nixos-generate-config --show-hardware-config
sudo nixos-rebuild switch --flake .#Ivaldi
```

Stow dotfiles from their separate repository: `stow -t ~ <package>`.

## Rebuild and update

```sh
sudo nixos-rebuild switch --flake .#Ivaldi
nix flake update   # a GitHub Action also does this daily
```

## T3 Code

This flake owns `t3`; skip the upstream `curl | sh` installer and never run it
as root. `nixos-rebuild` updates the command, while `t3 update` updates the
server runtime that `t3 service install` pins under `~/.t3`.

Lingering keeps the user service running after logout and starts it at boot.
TCP `3773` is open for LAN pairing only; T3 Connect does not need it, so keep it
unforwarded on the router.

Authenticate at least one provider over SSH before starting a thread:

```sh
claude auth login
codex login
agent login            # Cursor (binary: cursor-agent)
gh auth login          # so agents can open pull requests
pi                     # then /login, for Pi as a provider

t3 up --connect        # approve the printed link; installs the service
# t3 up --lan          # optional LAN/tailnet access; then `t3 pair`
t3 status
t3 service status
```

Sign in to the same T3 Connect account on the phone or Thor's desktop app and
choose the Ivaldi environment.

T3's headless Chrome runs through nix-ld instead of `t3 browser setup`. If a
browser tab names a missing library, add it to `programs.nix-ld.libraries` and
rebuild. Keep the browser sandbox on unless it is itself the blocker
(`T3CODE_SERVER_BROWSER_SANDBOX=0`).

## Secrets

Agenix is optional until you add a secret. Generate the key, paste the public
key under `ivaldi` in `secrets.nix`, then edit a secret:

```sh
sudo age-keygen -o /var/lib/agenix/age-key
sudo age-keygen -y /var/lib/agenix/age-key
nix run github:ryantm/agenix -- -e mysecret.age
```

Reference it from a host module:
`age.secrets.mysecret.file = ../../mysecret.age;`
