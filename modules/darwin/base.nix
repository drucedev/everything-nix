# Declares the `darwin.base` deferredModule option. Its content is contributed by
# the cross-class files (nix.nix, nixpkgs.nix, fonts.nix, packages/*); every
# nix-darwin host composes `darwin.base` into itself.
{ lib, ... }:

{
  options.darwin.base = lib.mkOption {
    type = lib.types.deferredModule;
    default = { };
  };
}
