# Pulls the agenix NixOS module into the nixosSystem eval via the eval-time
# module list. Per-host identityPaths live in nixos/thor/agenix.nix.
{ inputs, ... }:

{
  config.nixos.modules = [ inputs.agenix.nixosModules.default ];
}
