# Pulls the agenix nix-darwin module into the darwinSystem eval via the
# eval-time module list. Per-host identityPaths live in darwin/odin/agenix.nix.
{ inputs, ... }:

{
  config.darwin.modules = [ inputs.agenix.darwinModules.default ];
}
