# 2. Pin a nixpkgs input per host

Date: 2026-11-22

Status: Accepted

## Context

x86_64-darwin support ends with nixpkgs 26.05. The Linux hosts have no such
limit.

## Decision

- `nixpkgs` (`nixpkgs-26.05-darwin`) serves Odin and the default per-system
  tools; `darwin` follows it.
- `nixpkgs-stable` (`nixos-26.05`) serves Ivaldi.
- `nixpkgs-unstable` serves Thor.
- On x86_64-linux the dev shell uses `nixpkgs-unstable` to match Thor;
  x86_64-darwin stays on the default input.

## Consequences

`nixpkgs` and `darwin` stay on 26.05 while the Linux inputs may advance.
