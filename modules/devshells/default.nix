# Tools for working on this flake. agenix CLI deliberately omitted (no secrets
# yet); run ad-hoc: nix run github:ryantm/agenix -- -e secret.age
{ ... }:

{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.nixd
          pkgs.nixfmt
          pkgs.git
        ];
      };
    };
}
