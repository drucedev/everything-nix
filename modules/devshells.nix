# Dev shell for working on this flake (agenix CLI deliberately omitted — no
# secrets yet; run ad-hoc: nix run github:ryantm/agenix -- -e s.age).
# Language toolchains live in per-project flakes, not here.
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
      # Linux shells follow Thor's unstable nixpkgs; x86_64-darwin support
      # ends at 26.05, so darwin stays on the flake's default input.
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
