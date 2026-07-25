# The ONLY file calling nixosSystem / darwinSystem. Thor's external modules
# (disko, agenix) come in via config.nixos.modules; Odin's only one (agenix)
# is listed directly. Nothing is passed through specialArgs.
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

  options.darwin.base = lib.mkOption {
    type = lib.types.deferredModule;
    default = { };
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

  # Ivaldi — small home server, NixOS on the Linux-native stable input.
  config.flake.nixosConfigurations.Ivaldi = inputs.nixpkgs-stable.lib.nixosSystem {
    modules = config.nixos.modules ++ [
      { nixpkgs.hostPlatform = "x86_64-linux"; }
      {
        imports = [
          config.nixos.base
          config.nixos.ivaldi
          config.users.druce
        ];
      }
    ];
  };

  # Odin — nix-darwin on stable nixpkgs. nix-darwin still accepts the `system` arg.
  config.flake.darwinConfigurations.Odin = inputs.darwin.lib.darwinSystem {
    system = "x86_64-darwin";
    modules = [
      inputs.agenix.darwinModules.default
      {
        imports = [
          config.darwin.base
          config.darwin.odin
          config.users.druce
        ];
      }
    ];
  };
}
