# Install Odin

macOS with nix-darwin, x86_64-darwin.

First time: install Nix with flakes. The
[Determinate installer](https://github.com/DeterminateSystems/nix-installer)
in plain-Nix mode works; nix-darwin manages the Nix config afterwards. Then
install [nix-darwin](https://github.com/nix-darwin/nix-darwin).

```sh
darwin-rebuild switch --flake .#Odin
```

Dotfiles are not in this repo. Stow them from the separate repository:
`stow -t ~ <package>`.

Manually disable Spotlight shortcuts that conflict with Raycast hotkeys:
https://manual.raycast.com/hotkey

## Rebuild

```sh
darwin-rebuild switch --flake .#Odin
```

## Update

```sh
nix flake update
```

A GitHub Action also bumps `flake.lock` daily, within the pinned branches.
Do not repoint the `nixpkgs` or `darwin` inputs past their 26.05 branches.
26.05 is the last release that supports this machine's x86_64-darwin.
`nixpkgs-stable` and `nixpkgs-unstable` may advance.

## Secrets

Generate the age key and paste the public key into `secrets.nix` under `odin`:

```sh
sudo age-keygen -o /etc/age/age-key
sudo age-keygen -y /etc/age/age-key
nix run github:ryantm/agenix -- -e mysecret.age
```

Reference it from a host module:

```nix
age.secrets.mysecret.file = ../../mysecret.age;
```
