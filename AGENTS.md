# AGENTS.md

Dendritic Nix flake for Thor (NixOS desktop), Ivaldi (NixOS server), and Odin
(x86_64-darwin). Human install and rebuild steps live in `docs/<host>.md`;
`README.md` states only what the repository is.

## Safety

Verify with non-activating evaluation only: `nix eval` and
`nix flake check --no-build`. Never run `nixos-rebuild`, `darwin-rebuild`,
`disko`, `reboot`, or anything that activates a configuration or restarts
services, and never use `sudo` for system changes; hand those commands to the
user.

## Architecture

Every file under `modules/` is a flake-parts module auto-imported by
[import-tree](https://github.com/denful/import-tree)
([dendritic](https://github.com/mightyiam/dendritic)). Modules contribute to
shared options and never import one another.

- `modules/hosts.nix` alone calls `nixosSystem`/`darwinSystem`, composing the
  `deferredModule`s `<class>.base`, `<class>.<host>`, and the user modules.
  Never pass `specialArgs`.
- Host modules are functions so the system constructor injects `pkgs`;
  flake-parts provides no `pkgs` at module top level.
- disko and agenix join every NixOS eval through `config.nixos.modules`; Odin
  lists agenix directly in `hosts.nix`.
- Shared users live in `modules/users/<name>.nix`, host-only users in the host
  module. Dotfiles live in a separate GNU stow repository; keep home-manager
  out.

## Inputs

- `nixpkgs` (`nixpkgs-26.05-darwin`): Odin and per-system tools; `darwin`
  follows it.
- `nixpkgs-stable` (`nixos-26.05`): Ivaldi.
- `nixpkgs-unstable` (`nixos-unstable`): Thor.

Keep `nixpkgs` and `darwin` on 26.05, the last release supporting
x86_64-darwin; the Linux inputs may advance.

## Conventions

- `system.stateVersion` is set at install and never changed.
- Comments explain only non-obvious constraints or rationale.
- Commit only when asked, staging files by path, as Conventional Commits:
  `type: subject`, imperative, lowercase, no trailing period, at most 72
  characters.

## Verification

```sh
nix fmt
nix flake check --no-build
```

New files are invisible to the flake until tracked or added with `git add -N`.
CI evaluates Linux and x86_64-darwin separately; the automatic
`<host>-supported-packages` checks reject packages whose platforms do not match
the host OS. For refactors, compare evaluated behaviour before and after:
system package names, important option values, and the `drvPath`s of
devShells, checks, and the formatter.

## Adding a host

Add `modules/<class>/<name>.nix` with its `deferredModule` option and host
identity; the base is composed only in `hosts.nix`. For NixOS, add
`hardware.nix` and `disk.nix` (TODO device placeholder) under
`modules/nixos/<name>/`. Wire it in `hosts.nix` by copying the matching
composition block, and add an agenix identity and TODO key to `secrets.nix`
when needed.

## Agent skills

### Issue tracker

Local markdown under `.scratch/<feature>/`, gitignored. See
`docs/agents/issue-tracker.md`.

### Triage labels

The label vocabulary for tracker states and item types. See
`docs/agents/triage-labels.md`.
