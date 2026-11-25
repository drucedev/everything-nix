# Install Ivaldi

Headless NixOS home server, x86_64-linux: UEFI, GPT with an ESP, systemd-boot.
It carries the shared CLI baseline plus `tmux`, `age`, Pi, Claude Code, Open
Code Review (`ocr`), and the T3 Code server (`t3`) with its provider CLIs.

## Before the installer

1. On Thor, check what the install would build locally. Expect only small
   configuration derivations under "will be built"; Thor trusts the Numtide
   cache, so anything large there would also compile on Ivaldi's N100.

   ```sh
   nix build .#nixosConfigurations.Ivaldi.config.system.build.toplevel --dry-run
   ```

2. Reserve Ivaldi's wired MAC address in the UniFi Gateway (Client Devices →
   Settings → Fixed IP Address). The live USB and the installed system share
   the address. Add a UniFi Local DNS Record (Settings → Policy Table → DNS)
   mapping `ivaldi.lan` to it. SSH and T3 listen only on the wired interface,
   `enp1s0`.

3. SSH is key-only, with Thor's key already in `modules/nixos/ivaldi.nix`. Add
   any other public key to `users.users.druce.openssh.authorizedKeys.keys`
   there. The console password still works, including for `sudo`.

## Install from Thor

Boot the NixOS minimal installer in UEFI mode, on wired DHCP or Wi-Fi via
`nmtui`. On Ivaldi's console, set a temporary password for the live `nixos`
user:

```sh
passwd
```

Everything else runs on Thor. Authorize Thor's key and identify the disk:

```sh
ssh-copy-id -o HostKeyAlias=ivaldi-installer nixos@<ivaldi-ip>
ssh -o HostKeyAlias=ivaldi-installer nixos@<ivaldi-ip> \
  'lsblk -o NAME,PATH,SIZE,TYPE,MODEL,SERIAL,FSTYPE; ls -l /dev/disk/by-id'
```

If the disk changed, set `device` in `modules/nixos/ivaldi/disk.nix` to the
whole-disk `/dev/disk/by-id` entry, never a `-partN` one, then confirm:

```sh
nix eval --raw .#nixosConfigurations.Ivaldi.config.disko.devices.disk.main.device
```

Install with [nixos-anywhere](https://github.com/nix-community/nixos-anywhere).
It builds on Thor and copies the closure, so nothing compiles on Ivaldi. Skip
the reboot phase to set `druce`'s password first:

```sh
# WARNING: erases the disk configured in modules/nixos/ivaldi/disk.nix
# (512M ESP, 4G swap, ext4 root).
nix run github:nix-community/nixos-anywhere -- \
  --flake .#Ivaldi --build-on local --phases disko,install \
  --ssh-option HostKeyAlias=ivaldi-installer \
  --generate-hardware-config nixos-generate-config /tmp/ivaldi-hardware.nix \
  --target-host nixos@<ivaldi-ip>

ssh -t -o HostKeyAlias=ivaldi-installer nixos@<ivaldi-ip> \
  "sudo nixos-enter --root /mnt -c 'passwd druce'"
ssh -o HostKeyAlias=ivaldi-installer nixos@<ivaldi-ip> \
  'sudo umount -R /mnt && sudo reboot'
```

Merge `/tmp/ivaldi-hardware.nix` into `modules/nixos/ivaldi/hardware.nix`
when it differs, and commit. The root password stays unset; `sudo` covers it.

## First boot

Remove the USB, then `ssh druce@ivaldi.lan` from Thor.

Stow dotfiles from their separate repository: `stow -t ~ <package>`.

## Rebuild and update

Rebuild from Thor's checkout. Thor builds and signs the system, then copies it
over SSH. Thor's shell aliases pull first: `uu-ivaldi`, `uu-thor`, and `uu-all`
for both.

```sh
nixos-rebuild switch --flake .#Ivaldi \
  --target-host druce@ivaldi.lan --ask-sudo-password
nix flake update   # a GitHub Action also does this daily
```

If Ivaldi rejects a path as lacking a signature, Thor built it before the
signing key existed. Sign the closure, then rerun the rebuild:

```sh
sudo nix store sign --key-file /etc/nix/thor-signing-key --recursive \
  "$(nix build --no-link --print-out-paths \
    .#nixosConfigurations.Ivaldi.config.system.build.toplevel)"
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

t3 up --lan            # LAN access; installs the service
t3 pair                # pair Thor's app or the phone at http://ivaldi.lan:3773
# t3 up --connect      # optional remote access through T3 Connect
t3 status
t3 service status
```

With T3 Connect, sign in to the same account on the phone or Thor's desktop app
and choose the Ivaldi environment.

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
