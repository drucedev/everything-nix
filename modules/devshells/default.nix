# Default devshell (bare `nix develop`). Tools for working on this flake:
# nixd + nixfmt for editing, git. The agenix CLI is deliberately NOT here — there
# are no secrets yet, so it's unused weight. When the first .age secret is
# added, either re-add `inputs'.agenix.packages.default` here or run it ad-hoc
# via `nix run github:ryantm/agenix -- -e secret.age`. The agenix runtime modules
# (which decrypt secrets at activation) are unaffected and stay on both hosts.
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
