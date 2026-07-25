# Pulls the disko module into every nixosSystem eval (config lives in thor/disk.nix).
{ inputs, ... }:

{
  config.nixos.modules = [ inputs.disko.nixosModules.disko ];
}
