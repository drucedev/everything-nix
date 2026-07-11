# The integration capstone: declares the eval-time module lists for each class
# and produces the flake outputs `nixosConfigurations.Thor` and
# `darwinConfigurations.Odin`.
#
# This is the ONLY file that calls `nixosSystem` / `darwinSystem`. It has `inputs`
# in scope (a flake-parts module arg) and pulls external modules (disko, agenix)
# in via `config.nixos.modules` / `config.darwin.modules` — contributed by their
# own feature files. Lower-level modules only ever use the standard
# `{ pkgs, config, lib, ... }` args; nothing is passed through `specialArgs`
# (the dendritic `specialArgs` pass-thru anti-pattern is avoided).
{
  inputs,
  config,
  lib,
  ...
}:

{
  options.nixos.modules = lib.mkOption {
    type = lib.types.listOf lib.types.deferredModule;
    default = [ ];
    description = "Extra NixOS modules to include in every nixosSystem eval (e.g. disko, agenix).";
  };

  options.darwin.modules = lib.mkOption {
    type = lib.types.listOf lib.types.deferredModule;
    default = [ ];
    description = "Extra nix-darwin modules to include in every darwinSystem eval (e.g. agenix).";
  };

  # Thor — NixOS on nixpkgs-unstable. `nixpkgs.hostPlatform` is set in a module
  # rather than via the `system` arg to nixosSystem (the `system` arg is
  # deprecated on nixpkgs-unstable in favour of `nixpkgs.hostPlatform`).
  config.flake.nixosConfigurations.Thor = inputs.nixpkgs-unstable.lib.nixosSystem {
    modules = config.nixos.modules ++ [
      { nixpkgs.hostPlatform = "x86_64-linux"; }
      {
        imports = [
          config.nixos.base
          config.nixos.thor
          config.users.druce
        ];
      }
    ];
  };

  # Odin — nix-darwin on stable nixpkgs. nix-darwin still accepts the `system` arg.
  config.flake.darwinConfigurations.Odin = inputs.darwin.lib.darwinSystem {
    system = "x86_64-darwin";
    modules = config.darwin.modules ++ [
      {
        imports = [
          config.darwin.base
          config.darwin.odin
          config.users.druce
          config.users.liza
        ];
      }
    ];
  };
}
