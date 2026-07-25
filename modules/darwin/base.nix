# The reusable darwin base; cross-class files (nix.nix, packages/*, ...) merge into it.
{ lib, ... }:

{
  options.darwin.base = lib.mkOption {
    type = lib.types.deferredModule;
    default = { };
  };
}
