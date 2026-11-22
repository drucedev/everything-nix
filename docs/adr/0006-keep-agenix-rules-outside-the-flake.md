# 6. Keep agenix rules outside the flake

Date: 2026-11-22

Status: Accepted

## Context

agenix needs a rules file listing which host keys can decrypt each secret, and
an identity per host.

## Decision

- `secrets.nix` is read only by the `agenix` CLI; the flake never imports it.
- NixOS hosts read their identity from `/var/lib/agenix/age-key`. Odin reads
  `/etc/age/age-key`, which must be readable by root because darwin
  activation runs as root.

## Consequences

Key generation steps live in `docs/<host>.md`.
