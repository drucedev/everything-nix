# Install Ivaldi

NixOS home server, x86_64-linux. Headless: no desktop session. UEFI boot only.
The disk layout is GPT plus an ESP, and the bootloader is systemd-boot.

The system has the shared CLI tools (`git`, `gh`, `btop`, `neovim`, `stow`,
and the rest of the workstation CLI baseline), `tmux`, `age`, Pi, Open Code
Review (`ocr`), and the T3 Code server (`t3`, not the Electron app). T3's
provider CLIs are installed beside it: Claude Code, Codex, Cursor Agent, Grok,
and OpenCode.

## Before the installer

1. Point `device` in `modules/nixos/ivaldi/disk.nix` at the whole target disk,
   never a partition. From the installer:

   ```sh
   lsblk -o NAME,PATH,SIZE,TYPE,MODEL,SERIAL,FSTYPE,MOUNTPOINTS
   ls -l /dev/disk/by-id
   ```

2. SSH is key-only. Thor's key is already in `modules/nixos/ivaldi.nix`. Add
   any other public key (Odin, a laptop) to
   `users.users.druce.openssh.authorizedKeys.keys` in that file before
   installing. There is no SSH password login. The console password set below
   still works, including `sudo`.

3. Install from a checkout that contains those edits. Push them first if the
   installer will `git clone`, or edit the live checkout before disko.

## Install

From the NixOS minimal installer (UEFI boot, flakes enabled). Wired DHCP is
the expected first network; `nmtui` is available on the console if the machine
needs Wi-Fi.

```sh
# Keep the checkout outside /mnt; disko will use /mnt for the target system.
git clone <repo-url> /tmp/everything-nix
cd /tmp/everything-nix

# Confirm this is the whole target disk, never a partition.
readlink -f /dev/disk/by-id/<the-id-in-disk.nix>

# 1. Destroy, partition, format, and mount Ivaldi at /mnt.
#    WARNING: this erases the disk configured in modules/nixos/ivaldi/disk.nix.
#    Layout differs from Thor: 512M ESP, 4G swap, ext4 root.
sudo nix run github:nix-community/disko#disko -- \
  --mode destroy,format,mount \
  --flake .#Ivaldi

# 2. Install NixOS, set both passwords while /mnt is mounted, then reboot.
#    nixos-install prompts for the root password (console only; root SSH is off).
sudo nixos-install --flake .#Ivaldi --root /mnt
sudo nixos-enter --root /mnt -c 'passwd druce'
cd /
sudo umount -R /mnt
sudo reboot
```

## First boot

On the console, note the address (`ip -4 addr`), then from Thor:

```sh
ssh druce@<ivaldi-ip>
```

The live-installer checkout is temporary. Clone a persistent checkout, then
merge real hardware before the next rebuild:

```sh
git clone <repo-url> "$HOME/everything-nix"
cd "$HOME/everything-nix"

# Copy initrd modules, kernel modules, and anything else that is not a
# filesystem or swap entry. Disko owns the mounts; do not copy those.
sudo nixos-generate-config --show-hardware-config
# edit modules/nixos/ivaldi/hardware.nix, then:
sudo nixos-rebuild switch --flake .#Ivaldi
```

Dotfiles are not in this repo. Stow them from the separate repository:
`stow -t ~ <package>`.

## Rebuild

```sh
sudo nixos-rebuild switch --flake .#Ivaldi
```

## T3 Code

Do not install T3 with the upstream `curl | sh` script, and do not run it as
root. This flake owns the `t3` command. `nixos-rebuild` updates that command.
`t3 service install` pins a server runtime under `~/.t3`; `t3 update` updates
that runtime, not the Nix package.

Lingering is already enabled, so the user service survives logout and starts
at boot. TCP `3773` is open for LAN pairing and pinned with a systemd user
drop-in. T3 Connect does not need that port. Do not forward `3773` on the
router.

Authenticate at least one provider over SSH before starting a thread. Cursor's
binary is `cursor-agent`; its login command is `agent login`.

```sh
claude auth login
codex login
gh auth login          # so agents can open pull requests
pi                     # then /login, if you want Pi as a provider

# Remote access through T3 Connect (phone, browser, another desktop).
# Approve the printed link. This also installs the background service.
t3 up --connect

# Optional, same LAN or tailnet, in addition to Connect:
# t3 up --lan

t3 status
t3 service status
```

Sign in to the same T3 Connect account on the phone or on Thor's desktop app
and choose the Ivaldi environment. `t3 pair` prints a LAN link after `--lan`.

`t3 browser setup` is for Debian and Ubuntu. Ivaldi uses nix-ld instead, so
T3's downloaded headless Chrome can start. If a browser tab names a missing
library, add that package to `programs.nix-ld.libraries` and rebuild. Do not
set `T3CODE_SERVER_BROWSER_SANDBOX=0` unless the sandbox itself is blocked.

## Update

```sh
nix flake update
```

A GitHub Action also bumps `flake.lock` daily, within the pinned branches.
Do not repoint the `nixpkgs` or `darwin` inputs past their 26.05 branches.
26.05 is the last release that supports Odin's x86_64-darwin. `nixpkgs-stable`
and `nixpkgs-unstable` may advance.

## Secrets

Agenix is optional until you add a secret. Generate the key, paste the public
key into `secrets.nix` under `ivaldi`, then edit a secret:

```sh
sudo age-keygen -o /var/lib/agenix/age-key
sudo age-keygen -y /var/lib/agenix/age-key
nix run github:ryantm/agenix -- -e mysecret.age
```

Reference it from a host module:

```nix
age.secrets.mysecret.file = ../../mysecret.age;
```
