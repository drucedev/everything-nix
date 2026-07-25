# AGENTS.md

Guidance for AI agents working on this repo. User-facing install/rebuild
instructions live in README.md — keep them there; this file owns everything
about *how the repo is built*.

## Architecture

[Dendritic pattern](https://github.com/mightyiam/dendritic): every file under
`modules/` is a top-level [flake-parts](https://flake.parts) module,
auto-imported by [import-tree](https://github.com/denful/import-tree) (wired in
`flake.nix`). No file imports another — files contribute to shared options and
the module system merges them.

- `modules/hosts.nix` is the ONLY file calling `nixosSystem` / `darwinSystem`.
  Never pass `specialArgs`; modules use standard args only.
- `options.<class>.base` and `options.<class>.<host>` are `deferredModule`s.
  Cross-class files (`nix.nix`, `nixpkgs.nix`, `fonts.nix`, `packages.nix`)
  contribute to BOTH bases; `hosts.nix` composes base + host + users per eval.
- Host modules are functions (`{ pkgs, ... }:` or `{ ... }:`) so
  nixosSystem/darwinSystem injects `pkgs` — flake-parts provides none at
  top-level module scope.
- Host-only users live in the host file (liza in `darwin/odin.nix`); shared
  users live in `modules/users/<name>.nix` and are imported per host.
- External flake modules: Thor's (disko, agenix) come via
  `config.nixos.modules`, contributed by `nixos/disko.nix` / `nixos/agenix.nix`;
  Odin's single one (agenix) is listed directly in `hosts.nix`.

## nixpkgs inputs

| Input              | Branch                 | Used by                          |
| ------------------ | ---------------------- | -------------------------------- |
| `nixpkgs`          | `nixpkgs-26.05-darwin` | Odin (nix-darwin), perSystem     |
| `nixpkgs-stable`   | `nixos-26.05`          | Ivaldi (NixOS server)            |
| `nixpkgs-unstable` | `nixos-unstable`       | Thor (NixOS desktop)             |

CONSTRAINT: x86_64-darwin support ends at 26.05 — never repoint `nixpkgs` /
`darwin` past their 26.05 branches. `nixpkgs-stable` and `nixpkgs-unstable`
may advance.

## Layout

```
flake.nix                 inputs + mkFlake (import-tree ./modules)
secrets.nix               agenix CLI rules file — NOT a flake module
modules/                  auto-imported top-level modules
  systems.nix             systems perSystem is defined for
  hosts.nix               nixosSystem/darwinSystem calls + wiring options
  users.nix               options.users = attrsOf deferredModule
  users/druce.nix         druce (shared user; branches NixOS vs darwin)
  nix.nix                 nix settings/gc/optimise + btop  -> both bases
  nixpkgs.nix             allowUnfree                    -> both bases
  fonts.nix               fonts.packages                 -> both bases
  packages.nix            shared cli/dev/gui packages    -> both bases
  formatter.nix           perSystem.formatter
  checks.nix              perSystem.checks: host package platform guard
  devshells.nix           perSystem.devShells.{default,kotlin,zig}
  nixos/base.nix          options.nixos.base + programs.zsh.enable
  nixos/thor.nix          options.nixos.thor; desktop stack
  nixos/thor/{hardware,disk,agenix}.nix
  nixos/ivaldi.nix        options.nixos.ivaldi; minimal server scaffold
  nixos/ivaldi/{hardware,disk,agenix}.nix
  nixos/disko.nix         disko module  -> config.nixos.modules
  nixos/agenix.nix        agenix module -> config.nixos.modules
  darwin/odin.nix         options.darwin.odin; Odin identity + liza + agenix identity
.github/workflows/        check.yml (2-leg flake check), flake.yml (daily lock bump)
```

## Conventions

- `system.stateVersion`: set to the current stable release at install time;
  never change afterwards.
- Comments: only non-obvious constraints and rationale. No history lessons, no
  narrating the code — the pattern is documented in THIS FILE, once.
- Dotfiles are managed with GNU stow in a separate repo; home-manager was
  deliberately removed — do not reintroduce it.
- Git: Conventional Commits (`type: subject`, imperative lowercase, ≤72
  chars), stage files explicitly by path, commit directly to `main`.
- Session handoffs live in `.pi/handoffs/` (untracked).

## Verifying changes

```sh
nix fmt                     # nixfmt-tree; the repo must stay formatted
nix flake check --no-build  # evaluates everything; CI runs exactly this
```

- CI (`.github/workflows/check.yml`) has two legs: ubuntu-latest (covers
  x86_64-linux outputs) and macos-26-intel (x86_64-darwin outputs).
  `nix flake check` skips outputs of incompatible systems, so both are needed.
- `modules/checks.nix` emits `<host>-supported-packages` for every host
  (picked up automatically): fails evaluation if a host's
  `environment.systemPackages` contains a package whose `meta.platforms` lacks
  the host's OS family. This exists because CI is eval-only — a wrong-OS
  package otherwise fails only at install time.
- GOTCHA: new files are invisible to the git flake until at least
  `git add -N` — untracked files are not copied into the flake store. If a
  just-created module seems silently ignored, this is why.
- For refactors, pin behavior first: capture evaluated config before/after
  (sorted `environment.systemPackages` names, key option values, drvPaths of
  devShells/checks/formatter) and require zero diff. On Odin, additionally
  `nix store diff-closures /run/current-system <new-toplevel>` must be empty.

## Adding a new host

1. Create `modules/<class>/<name>.nix`: declare `options.<class>.<name>` as a
   `deferredModule`, set `config.<class>.<name>` to a function returning the
   host's identity only. Do NOT compose the base — `hosts.nix` does that.
2. (NixOS) Add `modules/<class>/<name>/{hardware,disk}.nix` contributing to
   the same option; `disk.nix` uses disko with a TODO device placeholder.
3. Wire it in `modules/hosts.nix` — copy the Ivaldi block for NixOS or the
   Odin block for darwin.
4. Shared user → add `modules/users/<user>.nix` and import it; host-only user
   → directly in the host file. If the host will hold secrets, add an agenix
   identity file and a TODO key in `secrets.nix`.
5. Verify with `nix flake check --no-build` — the `<name>-supported-packages`
   guard appears automatically.
