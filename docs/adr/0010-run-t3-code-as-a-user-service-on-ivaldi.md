# 10. Run T3 Code as a lingering user service on Ivaldi

Date: 2026-11-22

Status: Accepted

## Context

`t3 service install` creates and owns a systemd user unit. Ivaldi is headless.

## Decision

- Druce's user lingers, so the unit survives logout and starts at boot.
- `t3` puts provider CLIs only on its own PATH. Shells and the user unit need
  them, so they are installed system-wide.
- T3 downloads a headless Chrome that is not a Nix binary, and `t3 browser
  setup` installs its libraries with apt, which NixOS lacks. nix-ld supplies
  them.
- A drop-in on `t3code.service` only pins `T3CODE_PORT=3773`;
  `~/.t3/service.env` can still override it.
- TCP 3773 is open for LAN pairing only. T3 Connect is outbound and does not
  need it. Do not forward the port: a pairing code is the only LAN
  authentication, and T3 refuses public addresses when started with `--lan`.
