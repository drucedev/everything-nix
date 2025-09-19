{
  inputs,
  nixpkgs,
  darwin,
  hm-unstable,
  ...
}:
let
  systemConfig = system: {
    system = system;
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      nixpkgs.hostPlatform = system;
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
          hm-unstable
          ;
      };
      modules = [
        ./../../globals.nix
        ./shared.nix
        ./odin.nix
      ];
    };
}
