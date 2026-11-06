# Install Odin

macOS with nix-darwin, x86_64-darwin.

Install Nix with flakes (the
[Determinate installer](https://github.com/DeterminateSystems/nix-installer)
in plain-Nix mode works; nix-darwin manages the Nix config afterwards), then
[nix-darwin](https://github.com/nix-darwin/nix-darwin). Stow dotfiles from
their separate repository (`stow -t ~ <package>`), and disable the Spotlight
shortcuts that conflict with
[Raycast hotkeys](https://manual.raycast.com/hotkey).

## Rebuild and update

```sh
darwin-rebuild switch --flake .#Odin
nix flake update   # a GitHub Action also does this daily
```

`nixpkgs` and `darwin` stay on 26.05, the last release supporting
x86_64-darwin.

## Secrets

Generate the age key, paste the public key under `odin` in `secrets.nix`, then
edit a secret:

```sh
sudo age-keygen -o /etc/age/age-key
sudo age-keygen -y /etc/age/age-key
nix run github:ryantm/agenix -- -e mysecret.age
```

Reference it from a host module:
`age.secrets.mysecret.file = ../../mysecret.age;`
