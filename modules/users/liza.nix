# Liza — a login user on Odin (darwin) only. `modules/hosts.nix` imports
# `config.users.liza` solely into the darwin eval, so this module never runs in
# a NixOS context and needs no platform branch.
{ ... }:

{
  # `config.users.liza` stores a deferred module; modules/hosts.nix imports it
  # only into the darwin eval.
  config.users.liza =
    { ... }:
    {
      users.users.liza = {
        name = "liza";
        home = "/Users/liza";
        shell = "/bin/zsh";
      };
    };
}
