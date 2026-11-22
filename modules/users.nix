{ lib, ... }:
{
  options.users = lib.mkOption {
    type = lib.types.attrsOf lib.types.deferredModule;
    default = { };
    description = "Per-user modules keyed by username, imported per host.";
  };
}
