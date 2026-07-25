# Per-user modules (deferredModule keyed by name); hosts.nix imports them per host.
{ lib, ... }:
{
  options.users = lib.mkOption {
    type = lib.types.attrsOf lib.types.deferredModule;
    default = { };
    description = "Per-user modules keyed by username, imported per host.";
  };
}
