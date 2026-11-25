# 14. Sign Thor's builds for deployment to Ivaldi

Date: 2026-11-25

Status: Accepted

## Context

Ivaldi is rebuilt from Thor with `nixos-rebuild --target-host`, which copies
Thor's build outputs over SSH as `druce`. Ivaldi's Nix daemon rejects unsigned
paths from users it does not trust. Trusting `druce` there would make that
SSH login root-equivalent without the `sudo` password.

## Decision

- Thor's Nix daemon signs every path it builds with
  `/etc/nix/thor-signing-key`, a root-only local file outside the repository.
- Ivaldi trusts Thor's public key, `thor-1`.
- The secret key stays out of agenix: replacing a lost key costs one new key
  and one Ivaldi rebuild.

## Consequences

The key file must exist on Thor before Thor's configuration is activated.
Paths Thor built before the key existed stay unsigned until signed by hand.
Rotating the key means adding `thor-2` to Ivaldi before removing `thor-1`.
