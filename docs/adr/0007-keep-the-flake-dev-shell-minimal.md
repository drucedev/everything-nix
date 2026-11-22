# 7. Keep the flake's dev shell minimal

Date: 2026-11-22

Status: Accepted

## Decision

- The dev shell carries only `nixd` and `nixfmt`. Language toolchains live
  in per-project flakes, entered through `use flake` in `.envrc` files.
- The agenix CLI is omitted while there are no secrets; run it ad hoc with
  `nix run github:ryantm/agenix -- -e <file>.age`.
- `nix fmt` uses `nixfmt-tree`, because plain `nixfmt` deprecated directory
  arguments.
