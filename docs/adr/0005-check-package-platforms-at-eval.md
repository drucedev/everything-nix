# 5. Check package platforms during evaluation-only CI

Date: 2026-11-22

Status: Accepted

## Context

CI runs `nix flake check --no-build`, so nothing is built and a package that
cannot run on a host's OS would only fail at install time. `nix flake check`
also skips outputs for systems other than the runner's.

## Decision

- CI runs on `ubuntu-latest` and `macos-26-intel`. The legs cover different
  systems, so `fail-fast` is off and a failing leg does not cancel the other.
- A `<host>-supported-packages` check fails evaluation when a host's system or
  user packages declare `meta.platforms` without the host's OS. New hosts are
  picked up automatically.
- Platforms are compared by OS family, not full system triple: nixpkgs
  architecture annotations are often stricter than reality. `ghostty-bin`
  declares aarch64-darwin only but ships a universal binary that runs on
  x86_64-darwin.

## Consequences

`macos-26-intel` is the last x86_64-darwin runner label. If it queues forever,
enable billing or larger runners on the account.
