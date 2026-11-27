# 15. Run T3 Code and agents as an unprivileged user on Ivaldi

Date: 2026-11-27

Status: Accepted

## Context

T3 Code runs every provider CLI as its own child process. As `druce`, they
could read druce's SSH key and tokens, and `wheel` stood between them and root
only through the `sudo` password.

## Decision

- The `agent` user owns T3 Code's lingering user service, `~/.t3`, the
  provider logins, and the project checkouts. It is not in `wheel`, has no
  SSH login, and cannot write outside its home, `/tmp`, and the Nix daemon.
- Druce no longer lingers and joins the `agent` group. Agent's home is mode
  770, and the `t3code.service` drop-in sets `UMask=0007`, so files T3 creates
  are writable by druce. Credential files that CLIs create as mode 600 stay
  private to `agent`.
- The drop-in sets `NoNewPrivileges`, so setuid binaries such as `sudo`
  cannot raise the service's privileges.
- `agent` uses the host Nix daemon as an untrusted user, so projects can use
  devShells and direnv.
- A dedicated user was chosen over a NixOS container or microVM: it keeps
  T3's own service management and needs no port forwarding or separate store.

## Consequences

- Agents share the host network and can read world-readable files.
- Git, direnv, and build tools read configuration from the repository. Running
  them as druce in an agent checkout runs code that agents control, so inspect
  those checkouts as `agent` or review changes before running them as druce.
  Do not add agent checkouts to druce's `safe.directory`.
- Agents push with their own `gh` login. Give it a fine-grained token limited
  to the repositories they need.
