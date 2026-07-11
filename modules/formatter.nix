# Formatter for `nix fmt`. `pkgs.nixfmt-tree` walks a directory tree and formats
# every .nix file, so `nix fmt .` works without nixfmt's "passing directories is
# deprecated" warning (plain pkgs.nixfmt deprecated directory arguments in favour
# of this tree variant). nixfmt's default style is now the RFC style — the
# nixfmt-rfc-style alias was merged into nixfmt — matching what the zed config uses.
{ ... }:

{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      formatter = pkgs.nixfmt-tree;
    };
}
