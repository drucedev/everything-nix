# 4. Register user-facing packages in packages.nix

Date: 2026-11-22

Status: Accepted

## Context

Packages are spread across three hosts with different users and platforms.
Dotfiles live in a separate GNU stow repository.

## Decision

- `modules/packages.nix` is the single registry for user-facing packages.
  Host modules add only the runtime packages their own programs need.
- On Odin, Druce's apps are per-user (`users.users.druce.packages`) so Liza
  keeps only the shared baseline. Per-user apps are not linked into
  `/Applications/Nix Apps`, so Dock pins use store paths.
- Raycast is installed system-wide because it needs Launch Services
  visibility.
- Odin uses `ghostty-bin` to avoid a heavy source build on darwin.

## Consequences

Per-user package delivery must pass the same OS check as system packages
(ADR 0005).
