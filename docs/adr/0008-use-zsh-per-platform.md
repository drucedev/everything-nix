# 8. Use the platform's zsh for Druce

Date: 2026-11-22

Status: Accepted

## Decision

- On nix-darwin, Druce uses the system zsh at `/bin/zsh`, which is already in
  `/etc/shells`.
- On NixOS, Druce uses `pkgs.zsh`. NixOS requires `programs.zsh.enable` for
  that, so the NixOS base enables it.
- The user module splits into two `mkIf` branches because NixOS-only options
  such as `isNormalUser` do not exist on nix-darwin.
