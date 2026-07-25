# Dev shells. default: tools for working on this flake (agenix CLI deliberately
# omitted — no secrets yet; run ad-hoc: nix run github:ryantm/agenix -- -e s.age).
{ ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      devShells = {
        default = pkgs.mkShell {
          packages = [
            pkgs.nixd
            pkgs.nixfmt
            pkgs.git
          ];
        };

        kotlin = pkgs.mkShell {
          packages = with pkgs; [
            jdk
            gradle
            kotlin
            kotlin-language-server
          ];
        };

        zig = pkgs.mkShell {
          packages = with pkgs; [ zig ];
        };
      };
    };
}
