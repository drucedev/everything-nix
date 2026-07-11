# Pulls the disko NixOS module into the nixosSystem eval via the eval-time
# module list. The disko *config* (disko.devices) lives in nixos/thor/disk.nix;
# this file only contributes the option-defining module.
{ inputs, ... }:

{
  config.nixos.modules = [ inputs.disko.nixosModules.disko ];
}
