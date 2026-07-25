# The ONLY file calling nixosSystem / darwinSystem. External modules (disko,
# agenix) come in via config.nixos.modules / config.darwin.modules; nothing is
# passed through specialArgs.
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

  # Thor — NixOS on nixpkgs-unstable. hostPlatform is set in a module because
  # nixosSystem's `system` arg is deprecated on unstable.
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
