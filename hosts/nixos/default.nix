{
  inputs,
  nixpkgs,
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
  Thor =
    let
      inherit (systemConfig "x86_64-linux") system pkgs;
    in
    nixpkgs.lib.nixosSystem {
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
        ./thor
      ];
    };
}
