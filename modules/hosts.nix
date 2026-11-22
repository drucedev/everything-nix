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
