# Per-user modules. Each user is a deferredModule keyed by name; `modules/hosts.nix`
# imports the relevant `config.users.<name>` into each host's eval.
{ lib, ... }:
{
  options.users = lib.mkOption {
    type = lib.types.attrsOf lib.types.deferredModule;
    default = { };
    description = "Per-user modules keyed by username, imported per host.";
  };
}
