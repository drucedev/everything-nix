# AGENTS.md

Guidance for agents working on this repo. Keep user-facing install and rebuild
instructions in `README.md`; this file describes the repository and safe
verification.

## Safety

- Never run `nixos-rebuild`, `darwin-rebuild`, `disko`, `switch`, `boot`,
  `test`, `reboot`, or commands that restart or activate system services.
- Do not use `sudo` for system changes. Ask the user to run activation commands
  manually.
- For Nix verification, use only non-activating evaluations such as
  `nix eval` and `nix flake check --no-build`. These must not change the
  running system.

## Architecture

This is a [dendritic](https://github.com/mightyiam/dendritic) flake: every file
under `modules/` is a top-level flake-parts module, auto-imported by
[import-tree](https://github.com/denful/import-tree). Modules contribute to
shared options; they do not import one another.

- `modules/hosts.nix` is the only file that calls `nixosSystem` or
  `darwinSystem`. Never pass `specialArgs`.
- `options.<class>.base` and `options.<class>.<host>` are `deferredModule`s.
  `hosts.nix` composes the base, host, and user modules for each evaluation.
- Host modules are functions so `nixosSystem` or `darwinSystem` injects `pkgs`.
  Flake-parts does not provide `pkgs` at top-level module scope.
- Shared users live in `modules/users/<name>.nix`; host-only users live in the
  host module. Dotfiles are managed with GNU stow in a separate repository;
  do not reintroduce home-manager.
- Thor's disko and agenix modules are contributed through
  `config.nixos.modules`; Odin's agenix module is listed directly in
  `hosts.nix`.

## Inputs and host roles

- `nixpkgs`: `nixpkgs-26.05-darwin`, used by Odin and per-system tools.
- `nixpkgs-stable`: `nixos-26.05`, used by Ivaldi.
- `nixpkgs-unstable`: `nixos-unstable`, used by Thor.

x86_64-darwin support ends at 26.05. Never move `nixpkgs` or `darwin` beyond
that branch; the stable and unstable Linux inputs may advance.

Thor is the NixOS desktop, Ivaldi is the minimal NixOS server, and Odin is the
x86_64-darwin host. Important modules are:

```text
flake.nix                 inputs and mkFlake
modules/hosts.nix         host composition and system constructors
modules/nixos/thor.nix    Thor desktop configuration
modules/nixos/thor/       Thor hardware, disk, and agenix modules
modules/nixos/ivaldi.nix  Ivaldi server configuration
modules/darwin/odin.nix   Odin configuration
modules/users/             shared user modules
modules/checks.nix         host package-platform checks
```

## Conventions

- Set `system.stateVersion` at installation time and never change it later.
- Comments explain only non-obvious constraints or rationale.
- Use Conventional Commits: `type: subject`, imperative, lowercase, no trailing
  period, at most 72 characters. Stage files explicitly by path. Do not commit
  unless the user asks.
- Keep session handoffs in `.pi/handoffs/` (untracked).

## Verification

```sh
nix fmt
nix flake check --no-build
```

CI evaluates Linux and x86_64-darwin outputs in separate jobs. The automatic
`<host>-supported-packages` checks reject packages whose platforms do not match
the host OS. New files are invisible to the flake until tracked or added with
`git add -N`.

For refactors, compare evaluated behavior before and after: system package
names, important option values, and the `drvPath`s of devShells, checks, and the
formatter. Do not activate a configuration to verify it.

## Adding a host

1. Add `modules/<class>/<name>.nix` with a `deferredModule` option and a host
   identity function. Do not compose the base there.
2. For NixOS, add `hardware.nix` and `disk.nix` under the host directory; use a
   TODO device placeholder in `disk.nix`.
3. Wire the host in `modules/hosts.nix`, copying the matching NixOS or Darwin
   composition block.
4. Add shared users under `modules/users/`; put host-only users in the host
   module. Add an agenix identity and a TODO key in `secrets.nix` when needed.
5. Run `nix flake check --no-build`; the supported-packages guard is automatic.
