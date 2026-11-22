# 1. Compose hosts only in hosts.nix

Date: 2026-11-22

Status: Accepted

## Context

Every file under `modules/` is an auto-imported flake-parts module. Hosts need
external modules (disko, agenix) and a `pkgs` instance, but flake-parts
provides no `pkgs` at module top level.

## Decision

- `modules/hosts.nix` is the only file that calls `nixosSystem` or
  `darwinSystem`. Nothing is passed through `specialArgs`.
- External NixOS modules join every NixOS eval through `config.nixos.modules`.
  Odin's only external module, agenix, is listed directly in `hosts.nix`.
- Host modules (`nixos.thor`, `nixos.ivaldi`, `darwin.odin`) are functions,
  so the system constructor injects `pkgs`.
- NixOS hosts set `nixpkgs.hostPlatform` in a module because the
  `nixosSystem` `system` argument is deprecated on unstable. nix-darwin still
  accepts `system`, so Odin passes it directly.

## Consequences

Adding a host means copying a composition block in `hosts.nix`; no other module
needs to know about it.
