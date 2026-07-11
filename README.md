# everything-nix

Druce's Nix flake for two machines, structured with the
[dendritic pattern](https://github.com/mightyiam/dendritic): every non-entry-point
file is a module of a top-level [flake-parts](https://flake.parts) configuration,
auto-imported from `modules/` by [import-tree](https://github.com/denful/import-tree).

## Hosts

| Host  | Class      | nixpkgs           | System           |
| ----- | ---------- | ----------------- | ---------------- |
| Thor  | NixOS      | `nixos-unstable`  | `x86_64-linux`   |
| Odin  | nix-darwin | `nixpkgs-26.05`   | `x86_64-darwin`  |

## What this flake does and does not manage

- **System** configuration for both hosts: NixOS (`Thor`) and nix-darwin (`Odin`).
- **Per-user packages** are installed system-wide via `environment.systemPackages`.
- **Dotfiles** are NOT managed here. They live in a separate
  [GNU stow](https://www.gnu.org/software/stow/) repo; this flake only installs
  `stow` so you can deploy them on any host (`stow -t ~ <package>`).
- **home-manager is not used** — it was removed in favour of stow for dotfiles
  and system packages for tools.

## Layout

```
flake.nix                 entry point: mkFlake { inherit inputs; } (import-tree ./modules)
secrets.nix               agenix rules file (read by the `agenix` CLI; NOT imported by the flake)
modules/                  auto-imported top-level modules
  systems.nix             systems that perSystem is defined for
  hosts.nix               the ONLY file calling nixosSystem/darwinSystem; no specialArgs pass-thru
  users.nix               options.users = attrsOf deferredModule
  users/druce.nix         druce's user record (branches NixOS vs darwin)
  users/liza.nix          liza's user record (Odin only)
  nix.nix                 nix.settings / gc / optimise / btop  -> both bases (cross-class)
  nixpkgs.nix             nixpkgs.config.allowUnfree          -> both bases (cross-class)
  fonts.nix               fonts.packages                      -> both bases (cross-class)
  packages/{cli,dev,gui}.nix  shared packages                 -> both bases (cross-class)
  formatter.nix           perSystem.formatter = nixfmt-tree
  devshells/{default,kotlin,zig}.nix  perSystem.devShells.*
  nixos/base.nix          options.nixos.base (reusable NixOS base)
  nixos/thor.nix          options.nixos.thor; Thor identity + desktop stack (function form so pkgs is injected)
  nixos/thor/{hardware,disk,agenix}.nix  Thor's hardware, disko layout, agenix identity
  nixos/disko.nix         pulls inputs.disko.nixosModules.disko into the eval
  nixos/agenix.nix        pulls inputs.agenix.nixosModules.default into the eval
  darwin/base.nix         options.darwin.base (reusable darwin base)
  darwin/odin.nix         options.darwin.odin; Odin identity + settings (function form so pkgs is injected)
  darwin/odin/agenix.nix  Odin's agenix identity
  darwin/agenix.nix       pulls inputs.agenix.darwinModules.default into the eval
```

The pattern: `nixos.base` / `darwin.base` are `deferredModule` options whose
content is contributed by the cross-class files (they merge). `modules/hosts.nix`
imports both the base and the host module into each system eval
(`imports = [ config.nixos.base config.nixos.thor ... ]`), so both apply and
merge naturally. Host modules hold only their own identity + hardware + unique
bits, as functions `{ pkgs, ... }:` so `pkgs` is injected by nixosSystem /
darwinSystem at import time (flake-parts does not provide `pkgs` at the
top-level module scope). External flake modules (disko, agenix) are
pulled into the eval via `options.nixos.modules` / `options.darwin.modules`,
contributed by their own feature files — so `hosts.nix` never hardcodes them.

## Prerequisites

- Nix with flakes (e.g. the [Determinate installer](https://github.com/DeterminateSystems/nix-installer)).
- On macOS: also [nix-darwin](https://github.com/nix-darwin/nix-darwin) once Odin is set up.

## Bootstrap a clean NixOS machine (Thor)

The current dev machine is Thor. From the NixOS installer:

```sh
# 1. Boot the NixOS minimal installer (flakes enabled).

# 2. Get this flake and set the disk device.
git clone <your-repo-url> && cd everything-nix
# Edit modules/nixos/thor/disk.nix and replace the TODO device with the real
# disk by-id path (find it with: lsblk -o NAME,LINKS).

# 3. Partition + format + install in one step with disko (see
#    https://github.com/nix-community/disko for the current invocation):
sudo nix run github:nix-community/disko#disko-install -- --flake .#Thor --disk main /dev/nvme0n1
# (replace /dev/nvme0n1 with your disk; use the same device as in disk.nix)

# 4. Reboot, then set passwords:
#    sudo passwd druce

# 5. (For secrets) Generate Thor's age key:
sudo age-keygen -o /var/lib/agenix/age-key
# Paste the printed PUBLIC key into secrets.nix under `thor`.
```

## Bootstrap / update nix-darwin (Odin)

```sh
# First-time setup: install Nix + nix-darwin (see nix-darwin docs).

# Apply / rebuild from this repo:
darwin-rebuild switch --flake .#Odin

# (For secrets) Generate Odin's age key:
sudo age-keygen -o /etc/age/age-key
# Paste the public key into secrets.nix under `odin`.
```

## Rebuilding

```sh
# NixOS (Thor)
sudo nixos-rebuild switch --flake .#Thor

# nix-darwin (Odin)
darwin-rebuild switch --flake .#Odin
```

## Dev shells

```sh
nix develop            # tools for editing this flake (nixd, nixfmt, git)
nix develop .#kotlin
nix develop .#zig
```

## Formatting

```sh
nix fmt .              # uses nixfmt-tree (modules/formatter.nix)
```

## Secrets (agenix)

No secrets are defined yet. To add one:

```sh
# 1. Make sure each host's public key is in secrets.nix (see bootstrap above).
# 2. Create/edit an encrypted secret (run from the repo root). The agenix CLI
#    is not in the devshell; run it ad-hoc from the flake input:
nix run github:ryantm/agenix -- -e mysecret.age
# 3. Reference it in a module, e.g. add to a host module:
#    age.secrets.mysecret.file = ../../mysecret.age;
```

## Updating

```sh
nix flake update       # bumps flake.lock
```

A GitHub Action (`.github/workflows/flake.yml`) also bumps `flake.lock` daily,
and `.github/workflows/check.yml` runs `nix flake check --no-build` on every
push / pull request.

## Adding a new host

1. Create `modules/nixos/<name>.nix`: declare `options.nixos.<name>` as a
   `deferredModule`, then set `config.nixos.<name> = { pkgs, ... }: { ... }` (a
   function so `pkgs` is injected) with the host's identity + unique config.
   Do NOT compose `nixos.base` here — `hosts.nix` imports it separately.
2. (NixOS) Add `modules/nixos/<name>/{hardware,disk}.nix` for its hardware and
   disko layout, contributing to `config.nixos.<name>`.
3. Wire it in `modules/hosts.nix` — import `config.nixos.base` alongside the
   host module:
   ```nix
   flake.nixosConfigurations.<Name> = inputs.nixpkgs-unstable.lib.nixosSystem {
     modules = config.nixos.modules ++ [ { nixpkgs.hostPlatform = "..."; }
       { imports = [ config.nixos.base config.nixos.<name> config.users.<user> ]; } ];
   };
   ```
4. If the host needs its own user, add `modules/users/<user>.nix` and import it.

## Notes

- Manually disable Spotlight shortcuts that conflict with Raycast hotkeys: https://manual.raycast.com/hotkey
- Nix install (Determinate): https://github.com/DeterminateSystems/nix-installer
