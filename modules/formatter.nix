# `nix fmt` for the whole tree (plain nixfmt deprecated directory arguments).
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
