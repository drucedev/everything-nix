{ ... }:

{
  perSystem =
    {
      pkgs,
      system,
      inputs',
      ...
    }:
    let
      shellPkgs = if system == "x86_64-linux" then inputs'.nixpkgs-unstable.legacyPackages else pkgs;
    in
    {
      devShells.default = shellPkgs.mkShell {
        packages = [
          shellPkgs.nixd
          shellPkgs.nixfmt
        ];
      };
    };
}
