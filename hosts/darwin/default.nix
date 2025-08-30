{
  inputs,
  nixpkgs,
  darwin,
  home-manager,
  vars,
  globals,
  ...
}:
let
  systemConfig = system: {
    system = system;
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  };
in
{
  Odin =
    let
      inherit (systemConfig "x86_64-darwin") system pkgs;
    in
    darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit
          inputs
          system
          pkgs
          vars
          globals
          ;
      };
      modules = [
        globals
        ./odin.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.druce = ./../../users/druce.nix;
        }
      ];
    };
}
